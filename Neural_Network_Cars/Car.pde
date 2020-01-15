PVector start;

class Car {
  NeuralNetwork nn;
  
  PVector loc, vel, acc;
  float radius;

  float fitness;
  float fitnessMultiplier;

  float distTravelled;
  
  Sensor f, fr, fl, r, l;
  float frontS, frontRightS, frontLeftS, rightS, leftS;
  
  PImage carImage;

  //int step = 0;
  double[] steeringSpeed = new double[2]; //prvi element je steering, drugi brzina
  float topSpeed;
  
  double wallDist;
  boolean isDead;

  int col; // color of the car
  Car() {
    nn = new NeuralNetwork(5,4,3,2);
    
    start = new PVector(30,height/2); // Moguce izbaciti.
    loc = new PVector(start.x, start.y);
    acc = new PVector(0.1, 0);
    vel = new PVector();
    isDead = false;
    radius = 20; 
    steeringSpeed[0] = 0;
    steeringSpeed[1] = 0;
    topSpeed = 3;
    
    col = (int)random(255);
    carImage = stockAuto.copy();
    carImage.loadPixels();
     for(int i=0;i<800;i++){
        if(carImage.pixels[i] == color(0, 0, 0)){
          colorMode(HSB);
          carImage.pixels[i] = color(col,255,255);
          colorMode(RGB);
        }
    }

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 0.9;
  }


  void move() {

    if (!isDead) {
      update(); //Brzina i skretanje se postavljaju.

      vel.add(acc);
      loc.add(vel);
      distTravelled+= vel.get().mag();

      //Inicijalizacija senzora. (Kutevi:  0.349rad = 20deg, 0.873 = 50deg)   
      PVector norm = vel.get().normalize();
      f = new Sensor(loc, norm);                        //
      fr = new Sensor(loc, norm.get().rotate(0.349));   // (0.349 rad = 20 stupnjeva)
      fl = new Sensor(loc, norm.get().rotate(-0.349));  // Inicijalizacija i crtanje senzora.
      r = new Sensor(loc, norm.get().rotate(0.873));    // (0.873 rad = 50 stupnjeva)
      l = new Sensor(loc, norm.get().rotate(-0.873));   //

      frontS = f.see();  wallDist = frontS;  isDead();             //
      frontRightS = fr.see();   wallDist = frontRightS;  isDead(); //
      frontLeftS = fl.see();    wallDist = frontLeftS;  isDead();  // Omogucavanje senzorima da "vide" te provjeravanje ako je auto udario u zid (isDead() funkcija).
      rightS = r.see();  wallDist = rightS;  isDead();             // see() u Sensor class
      leftS = l.see();   wallDist = leftS;   isDead();             // isDead() u Car class
       
    }
  }



  void update() {
    
    double[] inputsForNN = {rightS,frontRightS,frontS,frontLeftS,leftS}; // Postavljanje value-i od senzori u input polje za NN.
    steeringSpeed = nn.feedForward(inputsForNN);  // Uzimanje outputa NN-a u polje steering-a i speed-a.
    
    //Utjecanje na skretanje auta. (-1 -> lijevo; 1 -> desno)
    float steeringAngle = map((float)steeringSpeed[0], -1, 1, -0.05, 0.05);
    acc.rotate(steeringAngle); 

    //Postavljanje limita na brzinu, tj. izravno utjecanje na brzinu auta.
    float speedLimit = map((float)steeringSpeed[1], -1, 1, 0, 3);
    if ((float)steeringSpeed[1] > 1) {
      vel.limit(topSpeed);
    } else if ((float)steeringSpeed[1] < -1) {
      vel.limit(0);
    } else {
      vel.limit(speedLimit);
    } 

    checkpointDetection();
    fitness = distTravelled * fitnessMultiplier;

    /*
    textSize(24);
    fill(0);
    text("fitness: " + fitness, 10, 30);
    text("multiplier: " + fitnessMultiplier, 10, 60);
    text("travelled: " + distTravelled, 10, 90);
    */
    

  }


  
  void checkpointDetection() {      // Provjerava je li auto došao do checkpointa te
                                    // postavlja fitness multiplier ovisno o tome.
    textSize(24);
    fill(0);
    stroke(255,0,0);
    int i = 0;
    for (Checkpoint c : cp) {
      if (dist(loc.x, loc.y, c.location.x, c.location.y) < c.radius/2) { 
        fitnessMultiplier = (i+1)*0.25 +1;   // Ako auto dođe do checkpointa tada se postavlja određeni multiplier.
        c.passed = true;        
      } 
    i++;
    }
    

  }


  
  void isDead() {      //Ispituje dali je auto udario u zid (ako je; "umire")
    //zid staze     
    if (wallDist <= 20) {
      isDead = true;;
    }
    //zid prozora
    else if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) {
      isDead = true;
    } else {
      isDead = false;
    }
  }



  void show() {
    float theta = vel.heading2D() + PI/2;   //Kut okretanja crteža auta.
    fill(210);
    noStroke();

    pushMatrix();
    translate(loc.x, loc.y);    
    //Crtanje senzornih zraka.
    if (!isDead) {
      f.show();
      fr.show();
      fl.show();
      r.show();
      l.show();
    }

    //Crtanje autića.    
    rotate(theta);
    rectMode(CENTER);
    if (!isDead) {
      
      //image(carImage,0,0);
      
      colorMode(HSB);
      fill(col, 255, 255);
      rect(0, 0, radius, 2*radius); //Tijelo auta
      colorMode(RGB);
      fill(0, 0, 255);
      rect(0, -radius/1.6, radius-radius/5, radius/2); // Vjetrobransko staklo
      
    } else {
      //image(grayAuto,0,0);
      
      fill(100);
      rect(0, 0, radius, 2*radius);
      fill(55);
      rect(0, -radius/1.6, radius-radius/5, radius/2);
      
    }

    popMatrix();
    //pisiPoEkranu();
  }
  
  void pisiPoEkranu(){
    textSize(24);
    fill(0);
    text("l: " + leftS, 10, 590); 
    text("fl: " + frontLeftS, 10, 620); 
    text("f: " + frontS, 10, 650); 
    text("fr: " + frontRightS, 10, 680); 
    text("r: " + rightS, 10, 710); 
  }

}
