
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

      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //Matematicki izracun za dobivanje tocke
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //do koje pojedini senzor "vidi".

      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        float tempX = x1 + (uA*(x2-x1));
        float tempY = y1 + (uA*(y2-y1));      
        tempUdaljenost = dist(x3, y3, tempX, tempY);

        if (tempUdaljenost < udaljenost) {
          udaljenost = tempUdaljenost;
          sjecisteX = tempX;    // Pronalazenje do koje tocke 
          sjecisteY = tempY;    // senzor vidi (ne vidi dalje od zida).
        }
      } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {
        udaljenost = sensorStrength;
      }
    }        
    colorMode(HSB);
    stroke(carColor, 255, 255);
    strokeWeight(6);
    //point(sjecisteX, sjecisteY); // ---------------------- FORA
    colorMode(RGB);

    strokeWeight(2);
    stroke(255, 230, 0, 55);
    //line(x3,y3,sjecisteX,sjecisteY);   // Crtanje dijela senzora koji oznacuje vidno polje. -------------------------------------------FORA

    return udaljenost; // Vraca udaljenost od zida.
  }

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

    return udaljenost;  // Vraca udaljenost od cilja.
  }
}
