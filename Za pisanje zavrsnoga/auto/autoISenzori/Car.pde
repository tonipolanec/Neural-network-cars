
PImage photo;

class Car {
  PVector loc, vel, acc;
  float radius;
  
  int col; // Color of car

  Car(float x, float y) {
    loc = new PVector(x, y);
    acc = new PVector(0.1, 0);
    vel = new PVector();
    radius = 20; 
    
    col = (int)random(255);

  }




  void show() {
    float theta = vel.heading2D() + PI/2;   //Kut okretanja crteža auta.
    fill(210);
    noStroke();

    pushMatrix();
    translate(loc.x, loc.y);    
    //Crtanje senzornih zraka.

    

    //Crtanje autića.    
    rotate(theta);
    rectMode(CENTER);
    if (true) {
    
    photo.loadPixels();
    for(int i=0;i<800;i++){
      if(photo.pixels[i] == color(0, 0, 0)){
        colorMode(HSB);
        photo.pixels[i] = color(col,255,255);
        colorMode(RGB);
      }
    }
      
      
    image(photo, 0, 0);
      /*
      fill(200, 0, 0);
      rect(0, 0, radius, 2*radius); //Tijelo auta
      fill(0, 0, 255);
      rect(0, -radius/1.6, radius-radius/5, radius/2); // Vjetrobransko staklo
      */
    } else {
      fill(100);
      rect(0, 0, radius, 2*radius);
      fill(55);
      rect(0, -radius/1.6, radius-radius/5, radius/2);
    }
    popMatrix();

  }

}
