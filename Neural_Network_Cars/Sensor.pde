
class Sensor {
  PVector dir;
  PVector loc;
  float x3, y3, x4, y4;
  float sensorStrength = 300;

  Sensor(PVector location_, PVector dir_) {
    dir = dir_.copy();
    loc = location_.copy();
    x3 = loc.x;
    y3 = loc.y;

    dir.setMag(sensorStrength);
    x4 = dir.x+loc.x;
    y4 = dir.y+loc.y;
  }

  void show() {
    
    //Crtanje senzora.
    stroke(255-backgroundColorGray);
    strokeWeight(1);
    line(0, 0, dir.x, dir.y);
  }


  float see(int carColor) {
    float tempUdaljenost = 0;
    float udaljenost = sensorStrength;
    float sjecisteX = loc.x, sjecisteY = loc.y;

    for (Obstacle o : m.obstacles) {

      float x1 = o.x1;
      float y1 = o.y1;
      float x2 = o.x2;
      float y2 = o.y2;

      // Matematicki izracun za dobivanje tocke do koje pojedini senzor "vidi".
      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1)); 
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1)); 

      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        float tempX = x1 + (uA*(x2-x1));
        float tempY = y1 + (uA*(y2-y1));      
        tempUdaljenost = dist(x3, y3, tempX, tempY);

        // Pronalazenje do koje tocke senzor vidi (ne vidi dalje od zida). 
        if (tempUdaljenost < udaljenost) {
          udaljenost = tempUdaljenost;
          sjecisteX = tempX;
          sjecisteY = tempY;  
        }
      } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {
        udaljenost = sensorStrength;
      }
    }        
    
    // Različiti načini prikazivanja senzora.
    if(sensorState == 3 || sensorState == 4){
      colorMode(HSB);
      stroke(carColor, 255, 255);
      strokeWeight(6);
      point(sjecisteX, sjecisteY);
      colorMode(RGB);
    }
    if(sensorState == 2 || sensorState == 3){
      strokeWeight(2);
      stroke(255, 230, 0, 155);
      line(x3,y3,sjecisteX,sjecisteY);   // Crtanje dijela senzora koji oznacuje vidno polje.
    }
    return udaljenost; // Vraca udaljenost od zida.
  }

  // Funkcija koja vraca udaljenost od ciljne linije.
  // (ako je cilj dovoljno blizu)
  float seeFinish(FinishLine fl) {
    float tempUdaljenost = 0;
    float udaljenost = sensorStrength;

    float x1 = fl.x1;
    float y1 = fl.y1;
    float x2 = fl.x2;
    float y2 = fl.y2;

    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      float tempX = x1 + (uA*(x2-x1));
      float tempY = y1 + (uA*(y2-y1));      
      tempUdaljenost = dist(x3, y3, tempX, tempY);

      if (tempUdaljenost < udaljenost) {
        udaljenost = tempUdaljenost;
      }
    } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {
      udaljenost = sensorStrength;
    }

    return udaljenost;
  }
}
