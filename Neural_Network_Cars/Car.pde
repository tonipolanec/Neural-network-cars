
Sensor f, fr, fl, r, l;
float frontS, frontRightS, frontLeftS, rightS, leftS;



class Car {
  PVector loc, vel, acc;
  float radius;

  float fitness;
  float fitnessMultiplier;

  float distTravelled;


  //int step = 0;
  float steering, speed, topSpeed;

  Car(float x, float y) {
    loc = new PVector(x, y);
    acc = new PVector(0.1, 0);
    vel = new PVector();
    radius = 20; 
    steering = 0;
    speed = 0;
    topSpeed = 3;

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 0.9;
  }


  void move() {

    if (!isDead()) {
      update(); //Brzina i skretanje se postavljaju.

      vel.add(acc);
      loc.add(vel);
      distTravelled+= vel.get().mag();

      //Inicijalizacija senzora. (Kutevi:  0.349rad = 20deg, 0.873 = 50deg)   
      PVector norm = vel.get().normalize();
      f = new Sensor(loc, norm);
      fr = new Sensor(loc, norm.get().rotate(0.349));
      fl = new Sensor(loc, norm.get().rotate(-0.349));
      r = new Sensor(loc, norm.get().rotate(0.873));
      l = new Sensor(loc, norm.get().rotate(-0.873));

      frontS = f.see();
      frontRightS = fr.see();
      frontLeftS = fl.see();
      rightS = r.see();
      leftS = l.see();
    }
  }



  void update() {

    //Utjecanje na skretanje auta. (-1 -> lijevo; 1 -> desno)
    float steeringAngle = map(steering, -1, 1, -0.05, 0.05);
    acc.rotate(steeringAngle); 

    //Postavljanje limita na brzinu, tj. izravno utjecanje na brzinu auta.
    float speedLimit = map(speed, -1, 1, 0, 3);
    if (speed > 1) {
      vel.limit(topSpeed);
    } else if (speed < -1) {
      vel.limit(0);
    } else {
      vel.limit(speedLimit);
    } 

    checkpointDetection();
    fitness = distTravelled * fitnessMultiplier;


    textSize(24);
    fill(0);
    text("fitness: " + fitness, 10, 30);
    text("multiplier: " + fitnessMultiplier, 10, 60);
    text("travelled: " + distTravelled, 10, 90);


    //println(speed);
  }


  // Provjerava je li auto došao do checkpointa te
  // postavlja fitness multiplier ovisno o tome.
  void checkpointDetection() {
    
    textSize(24);
    fill(0);
    stroke(255,0,0);
    int i = 0;
    for (Checkpoint c : cp) {
      if (dist(loc.x, loc.y, c.location.x, c.location.y) < c.radius/2) { 
        fitnessMultiplier = (i+1)*0.25 +1; // Ako auto dođe do cp-a tada se postavlja određeni multiplier.
        c.passed = true;        
      } 
    i++;
    }
    

  }


  //Ispituje dali je auto udario u zid (ako je; "umire")
  boolean isDead() {
    //zid stazeii      
    if (wallDist <= 20) {
      return true;
    }
    //zid prozora
    else if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) {
      return true;
    } else {
      return false;
    }
  }



  void show() {
    float theta = vel.heading2D() + PI/2; //Kut okretanja crteža auta.
    fill(210);
    noStroke();

    pushMatrix();
    translate(loc.x, loc.y);    
    //Crtanje senzornih zraka.
    if (!isDead()) {
      f.show();
      fr.show();
      fl.show();
      r.show();
      l.show();
    }

    //Crtanje autića.    
    rotate(theta);
    rectMode(CENTER);
    if (!isDead()) {
      fill(200, 0, 0);
      rect(0, 0, radius, 2*radius); //Auto
      fill(0, 0, 255);
      rect(0, -radius/1.6, radius-radius/5, radius/2); // Vjetrobransko staklo
    } else {
      fill(100);
      rect(0, 0, radius, 2*radius);
      fill(55);
      rect(0, -radius/1.6, radius-radius/5, radius/2);
    }

    popMatrix();
  }
}
