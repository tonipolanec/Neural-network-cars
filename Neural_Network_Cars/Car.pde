PVector start;

class Car {
  NeuralNetwork nn;

  int generation;

  PVector start;

  PVector loc, vel, acc;
  float radius = 20;

  float fitness = 0;
  float fitnessMultiplier = 1;
  double normFitness;

  float distTravelled = 0;

  Sensor f, fr, fl, r, l;
  Sensor sensors[] = new Sensor[5];
  float frontS, frontRightS, frontLeftS, rightS, leftS;

  PImage carImage;
  PImage finishedCarImage;

  double[] steeringSpeed = {0, 0}; //prvi element je steering, drugi brzina
  float topSpeed = 3;
  //FloatList speedsForAvg = new FloatList();
  //float avgSpeed = 0;

  double wallDist;
  float[] wallDists = new float[5];
  
  boolean isDead = false;
  boolean finished = false;
  boolean bestCar = false;

  int col; // color of the car

  Car() {
    nn = new NeuralNetwork(5, 4, 3, 2);

    generation = 1;
    start = startingPoint;
    loc = new PVector(m.startingPoint.x, m.startingPoint.y);
    acc = new PVector(0.1, 0);
    vel = new PVector();

    col = (int)random(255);
    carImage = coloringCar(stockAuto.copy(), col);
    finishedCarImage = coloringCar(glowingAuto.copy(), col);
  }

  Car(NeuralNetwork _nn, int _gen, int _col) {
    nn = _nn;

    generation = _gen;
    start = startingPoint;
    loc = new PVector(m.startingPoint.x, m.startingPoint.y);
    acc = new PVector(0.1, 0);
    vel = new PVector();

    col = _col;
    carImage = coloringCar(stockAuto.copy(), col);
    finishedCarImage = coloringCar(glowingAuto.copy(), col);
  }

  void move() {

    if (!isDead && !finished) {
      update(); //Brzina i skretanje se postavljaju.

      vel.add(acc);
      loc.add(vel);
      
      
      distTravelled+= vel.copy().mag();

      //Inicijalizacija senzora. (Kutevi:  0.349rad = 20deg, 0.873 = 50deg)   
      PVector front = vel.copy().normalize();
      
      sensors[0] = new Sensor(loc, front);                        //
      sensors[1] = new Sensor(loc, front.copy().rotate(0.349));   // (0.349 rad = 20 stupnjeva)
      sensors[2] = new Sensor(loc, front.copy().rotate(-0.349));  // Inicijalizacija i crtanje senzora.
      sensors[3] = new Sensor(loc, front.copy().rotate(0.873));    // (0.873 rad = 50 stupnjeva)
      sensors[4] = new Sensor(loc, front.copy().rotate(-0.873));   //
      
     /* 
      f = new Sensor(loc, front);                        //
      fr = new Sensor(loc, front.copy().rotate(0.349));   // (0.349 rad = 20 stupnjeva)
      fl = new Sensor(loc, front.copy().rotate(-0.349));  // Inicijalizacija i crtanje senzora.
      r = new Sensor(loc, front.copy().rotate(0.873));    // (0.873 rad = 50 stupnjeva)
      l = new Sensor(loc, front.copy().rotate(-0.873));   //
      */
      
      if (sensors[0].seeFinish(m.finishLine) < 20) {
        finished = true; // Za finish gleda samo senzor koji gleda ravno.
        isDead = false;
      }
      
      
      for(int i=0; i< sensors.length; i++){
        wallDists[i] = sensors[i].see();    
      }

      /*
      frontS = f.see();  
      wallDists[0] = f.see();;           
      frontRightS = fr.see();    
      wallDists[1] = fr.see();       
      frontLeftS = fl.see();     
      wallDists[2] = fl.see();  // Omogucavanje senzorima da "vide" te dodavanje distance od svakog senzora u polje
      leftS = l.see();           
      wallDists[3] = l.see();             
      rightS = r.see();          
      wallDists[4] = r.see();  
      */

      float minWD = wallDists[4];
      for (int i=0; i<wallDists.length-1; i++) {
        if (wallDists[i] < minWD)
          minWD = wallDists[i]; // Postavljanje najmanjeg distance-a za provjeravanje je li auto udario u zid.
      }
      wallDist = minWD; 
      isDead();

      int sec = population.sw.second();
      //println(sec);
      if (fitnessMultiplier < 1.25 && sec > 25) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 1.5 && sec > 35) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 1.75 && sec > 45) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 2 && sec > 60) {
        isDead = true;
        fitness = 1;
      }
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
      image(finishedCarImage, 0, 0);
    } else if (isDead) {
      image(grayAuto, 0, 0);
    } else {
      //tint(255, 255, 255, 156); 
      image(carImage, 0, 0);
    }

    /*
    if (isDead && avgSpeed == 0) {
      float allSpeeds = 0;
      for (int i=0; i< speedsForAvg.size(); i++) {
        allSpeeds += speedsForAvg.get(i);
      }
      avgSpeed = allSpeeds/(speedsForAvg.size());
    }
    */

    // Ispis podataka svakog autica.
    textSize(12);
    fill(0, 0, 0);
    //text(fitnessMultiplier,15,15);
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

    //double[] inputsForNN = {rightS, frontRightS, frontS, frontLeftS, leftS}; // Postavljanje value-i od senzori u input polje za NN.
    double[] inputsForNN = {wallDists[0], wallDists[1], wallDists[2], wallDists[3], wallDists[4]},
    steeringSpeed = nn.feedForward(inputsForNN);  // Uzimanje outputa NN-a u polje steering-a i speed-a.

    // steeringSpeed[0] -> iznos skretanja, steeringSpeed[1] -> iznos brzine
    //Utjecanje na skretanje auta. (-1 -> lijevo; 1 -> desno)
    float steeringAngle = map((float)steeringSpeed[0], -1, 1, -0.05, 0.05);
    acc.rotate(steeringAngle); 

    //Postavljanje limita na brzinu, tj. izravno utjecanje na brzinu auta.
    float speed = map((float)steeringSpeed[1], -1, 1, 1, topSpeed);
    vel.limit(speed);

    //speedsForAvg.append((float)speed);

    checkpointDetection();
    fitness = distTravelled * fitnessMultiplier;
  }



  void checkpointDetection() {      // Provjerava je li auto došao do checkpointa te
    // postavlja fitness multiplier ovisno o tome.
    textSize(24);
    fill(0);
    stroke(255, 0, 0);
    for (Checkpoint c : m.checkpoints) {
      if (dist(loc.x, loc.y, c.location.x, c.location.y) < c.radius/2) { 
        fitnessMultiplier = c.multiplier;   // Ako auto dođe do checkpointa tada se postavlja određeni multiplier.
        c.passed = true;
      }
    }
  }

  // Crtanje senzornih zraka
  void showSensors() {
    if (!isDead) {
      f.show();
      fr.show();
      fl.show();
      r.show();
      l.show();
    }
  }

  PImage coloringCar(PImage carImage, int col) {
    carImage.loadPixels();
    int dimensionsPic = carImage.height * carImage.width;
    for (int i=0; i<dimensionsPic; i++) {
      if (carImage.pixels[i] == color(0, 0, 0)) {
        colorMode(HSB);
        carImage.pixels[i] = color(col, 255, 255);
        colorMode(RGB);
      }
    }
    return carImage;
  }

}
