

class Checkpoint {

  PVector location;
  float radius;
  boolean passed;

  Checkpoint(float x, float y, float r) {
    location = new PVector(x, y);
    radius = r;    
    passed = false;
  }

  void show() {
    fill(0, 0, 0);
    ellipse(location.x, location.y, 3, 3);

    noStroke();
    fill(0, 200, 0, 105);
    ellipse(location.x, location.y, radius, radius);
  }
}


void inicijalizacijaCheckpointi() {
  cp[0] = new Checkpoint(510, 260, 130);
  cp[1] = new Checkpoint(850, 185, 150);
  cp[2] = new Checkpoint(800, 600, 150);
  cp[3] = new Checkpoint(1100, 550, 150);
  cp[4] = new Checkpoint(1150, 50, 150);
}
