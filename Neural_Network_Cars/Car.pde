PVector start;

class Car {
  NeuralNetwork nn;

  int generation;

  PVector start;

  PVector loc, vel, acc;
  float radius;

  float fitness;
  float fitnessMultiplier;
  double normFitness;

  //double percFitness; // Percentage ukupnog fitnessa od svih u populaciji.

  float distTravelled;

  Sensor f, fr, fl, r, l;
  float frontS, frontRightS, frontLeftS, rightS, leftS;

  PImage carImage;

  //int step = 0;
  double[] steeringSpeed = new double[2]; //prvi element je steering, drugi brzina
  float topSpeed;

  double wallDist;
  boolean isDead;
  boolean finished;

  int col; // color of the car
  Car() {
    nn = new NeuralNetwork(5, 4, 3, 2);

    generation = 1;
    start = startingPoint;
    loc = new PVector(start.x, start.y);
    acc = new PVector(0.1, 0);
    vel = new PVector();
    isDead = false;
    finished = false;
    radius = 20; 
    steeringSpeed[0] = 0;
    steeringSpeed[1] = 0;
    topSpeed = 3;

    col = (int)random(255);
    //carImage = stockAuto.copy();
    carImage = stockAuto.copy();
    carImage.loadPixels();
    int dimensionsPic = carImage.height * carImage.width;
    for (int i=0; i<dimensionsPic; i++) {
      if (carImage.pixels[i] == color(0, 0, 0)) {
        colorMode(HSB);
        carImage.pixels[i] = color(col, 255, 255);
        colorMode(RGB);
      }
    }

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 1;
  }

  Car(NeuralNetwork _nn, int _gen, int _col) {
    nn = _nn;

    generation = _gen;
    start = startingPoint;
    loc = new PVector(start.x, start.y);
    acc = new PVector(0.1, 0);
    vel = new PVector();
    isDead = false;
    finished = false;
    radius = 20; 
    steeringSpeed[0] = 0;
    steeringSpeed[1] = 0;
    topSpeed = 3;

    col = _col;
    carImage = stockAuto.copy();
    carImage.loadPixels();
    int dimensionsPic = carImage.height * carImage.width;
    for (int i=0; i<dimensionsPic; i++) {
      if (carImage.pixels[i] == color(0, 0, 0)) {
        colorMode(HSB);
        carImage.pixels[i] = color(col, 255, 255);
        colorMode(RGB);
      }
    }

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 1;
  }

  void move() {

    if (!isDead) {
      update(); //Brzina i skretanje se postavljaju.

      vel.add(acc);
      loc.add(vel);
      distTravelled+= vel.copy().mag();

      //Inicijalizacija senzora. (Kutevi:  0.349rad = 20deg, 0.873 = 50deg)   
      PVector norm = vel.copy().normalize();
      f = new Sensor(loc, norm);                        //
      fr = new Sensor(loc, norm.copy().rotate(0.349));   // (0.349 rad = 20 stupnjeva)
      fl = new Sensor(loc, norm.copy().rotate(-0.349));  // Inicijalizacija i crtanje senzora.
      r = new Sensor(loc, norm.copy().rotate(0.873));    // (0.873 rad = 50 stupnjeva)
      l = new Sensor(loc, norm.copy().rotate(-0.873));   //

      float[] wallDists = new float[5];
      
      if(f.seeFinish(finish) < 30){
        finished = true;
        isDead = true;
      }

      frontS = f.see();  
      wallDists[0] = frontS;           
      frontRightS = fr.see();    
      wallDists[1] = frontRightS;       
      frontLeftS = fl.see();     
      wallDists[2] = frontLeftS;  // Omogucavanje senzorima da "vide" te dodavanje distance od svakog senzora u polje
      leftS = l.see();           
      wallDists[3] = leftS;             
      rightS = r.see();          
      wallDists[4] = rightS;  

      float minWD = wallDists[4];
      for (int i=0; i<wallDists.length-1; i++) {
        if (wallDists[i] < minWD)
          minWD = wallDists[i]; // Postavljanje najmanjeg distance-a za provjeravanje je li auto udario u zid.
      }
      wallDist = minWD; 
      isDead();

      int sec = population.sw.second();
      //println(sec);
      if (fitnessMultiplier < 1.25 && sec > 15)
        isDead = true;
      else if (fitnessMultiplier < 1.5 && sec > 30)
        isDead = true;
      else if (fitnessMultiplier < 1.75 && sec > 45)
        isDead = true;
      else if (fitnessMultiplier < 2 && sec > 60)
        isDead = true;
    }
  }

  void show() {
    float theta = vel.heading() + PI/2;   //Kut okretanja crteža auta.
    fill(210);
    noStroke();

    pushMatrix();
    translate(loc.x, loc.y);    
    
    //Crtanje senzornih zraka.
    //showSensors();
    
    // Crtanje autića.    
    rotate(theta);

    imageMode(CENTER);
    if (finished) {
      image(glowingAuto, 0, 0);
    }else if(isDead){
      image(grayAuto, 0, 0);
    }else{
      //tint(255, 255, 255, 156); 
      image(carImage, 0, 0);
    }


    // Ispis podataka svakog autica.
    textSize(12);
    fill(0, 0, 0);
    //text((int)fitness,15,15);
    //text(generation,15,15);


    popMatrix();
  }


  void isDead() {      //Ispituje dali je auto udario u zid (ako je; "umire")
    //zid staze     
    if (wallDist <= 20) {
      isDead = true;
    } else {
      //zid prozora
      if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) {
        isDead = true;
      } else {
        isDead = false;
      }
    }
  }



  void update() {

    double[] inputsForNN = {rightS, frontRightS, frontS, frontLeftS, leftS}; // Postavljanje value-i od senzori u input polje za NN.
    steeringSpeed = nn.feedForward(inputsForNN);  // Uzimanje outputa NN-a u polje steering-a i speed-a.

    //Utjecanje na skretanje auta. (-1 -> lijevo; 1 -> desno)
    float steeringAngle = map((float)steeringSpeed[0], -1, 1, -0.05, 0.05);
    acc.rotate(steeringAngle); 

    //Postavljanje limita na brzinu, tj. izravno utjecanje na brzinu auta.
    float speedLimit = map((float)steeringSpeed[1], -1, 1, 0.5, 3);
    if ((float)steeringSpeed[1] > 1) {
      vel.limit(topSpeed);
    } else if ((float)steeringSpeed[1] < -1) {
      vel.limit(0);
    } else {
      vel.limit(speedLimit);
    } 

    checkpointDetection();
    fitness = distTravelled * fitnessMultiplier;
  }



  void checkpointDetection() {      // Provjerava je li auto došao do checkpointa te
    // postavlja fitness multiplier ovisno o tome.
    textSize(24);
    fill(0);
    stroke(255, 0, 0);
    int i = 0;
    for (Checkpoint c : cp) {
      if (dist(loc.x, loc.y, c.location.x, c.location.y) < c.radius/2) { 
        fitnessMultiplier = (i+1)*0.25 +1;   // Ako auto dođe do checkpointa tada se postavlja određeni multiplier.
        c.passed = true;
      } 
      i++;
    }
  }
  
  // Crtanje senzornih zraka
  void showSensors(){
    if (!isDead) {
      f.show();
      fr.show();
      fl.show();
      r.show();
      l.show();
    }
  }
  
  /*
  void restartCar(){
   
   start = startingPoint;
   loc = new PVector(start.x, start.y);
   acc = new PVector(0.1, 0);
   vel = new PVector();
   isDead = false;
   radius = 20; 
   steeringSpeed[0] = 0;
   steeringSpeed[1] = 0;
   topSpeed = 3;
   distTravelled = 0;
   fitness = 0;
   fitnessMultiplier = 1;
   
   }
   
   */




  void pisiPoEkranu() {
    textSize(24);
    fill(0);
    text("l: " + leftS, 10, 590); 
    text("fl: " + frontLeftS, 10, 620); 
    text("f: " + frontS, 10, 650); 
    text("fr: " + frontRightS, 10, 680); 
    text("r: " + rightS, 10, 710);
  }
}
