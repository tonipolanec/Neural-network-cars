
class Map{
  
  int index;
  
  Obstacle[] obstacles;
  Checkpoint[] checkpoints;
  FinishLine finishLine;
  PVector startingPoint;

  Map(int indexOfAMap){
    index = indexOfAMap;
    
    obstacles = inicijalizacijaObstaclei();
    checkpoints = inicijalizacijaCheckpointi();
    finishLine = inicijalizacijaFinishLinea();
    startingPoint = inicijalizacijaStartingPointa();


  }


  Obstacle[] inicijalizacijaObstaclei(){
    String[] lines = loadStrings("maps/" + index + "/obstacles.txt");
    Obstacle[] obst = new Obstacle[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      obst[i] = new Obstacle(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return obst;
  }

  Checkpoint[] inicijalizacijaCheckpointi(){
    String[] lines = loadStrings("maps/" + index + "/checkpoints.txt");
    Checkpoint[] cp = new Checkpoint[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      cp[i] = new Checkpoint(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return cp;
  }

  FinishLine inicijalizacijaFinishLinea(){
    String[] lines = loadStrings("maps/" + index + "/finishline.txt");
    FinishLine fl;
    String[] nums = lines[0].split(",",4);
    String[] slika = lines[1].split(",",2);
   
    fl = new FinishLine(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]), Float.parseFloat(slika[0]), Float.parseFloat(slika[1]));
    
    return fl;
  }
  
  PVector inicijalizacijaStartingPointa(){
    String[] lines = loadStrings("maps/" + index + "/startingpoint.txt");
    PVector sp;
    String[] nums = lines[0].split(",",2);
   
    sp = new PVector(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]));
    
    return sp;
  }


  void showObstacles(){   
    for(Obstacle o : obstacles){
      o.show();
    }  
  }

  void showCheckpoints(){   
    for(Checkpoint c : checkpoints){
      c.show();
    }  
  }
  
  void showFinishLine(){
    finishLine.show();
  }


}

class Obstacle{
  float x1,y1,x2,y2;
  
  /*Obstacle(PVector start, PVector end){
    x1 = start.x;
    y1 = start.y;
    //vector = end.get();
  }
  */
  Obstacle(float x1_, float y1_, float x2_, float y2_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }
  
  void show(){
    stroke(c);
    strokeWeight(5);
    //line(x1,y1,vector.x,vector.y);
    line(x1,y1,x2,y2);
  }
}

class Checkpoint{
  
  PVector location;
  float radius;
  boolean passed;
  float multiplier;

    Checkpoint(float x,float y, float r, float _multiplier){
      location = new PVector(x,y);
      radius = r;    
      passed = false;
      multiplier = _multiplier;
    }

  void show(){
    noStroke();
    fill(0,200,0,105);
    ellipse(location.x,location.y,radius,radius);
  }
}

class FinishLine {
  float x1, y1, x2, y2;
  
  //Za sliku finish line-a.
  float sx1, sy1;

  FinishLine(float _x1, float _y1, float _x2, float _y2, float _sx1, float _sy1) {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    
    sx1 = x1 + _sx1;
    sy1 = y1 + _sy1;

  }

  void show() {
    stroke(255, 242, 0);
    strokeWeight(3);
    line(x1, y1, x2, y2);
    
    if(m.index != 3){
      imageMode(CORNER);
      image(finishLine, m.finishLine.sx1, m.finishLine.sy1);
    }
  }
  
}

void showDifficulty(int x, int y, String text){
  pushMatrix();
    translate(x+20,y+20);
    rotate(-PI/5);
    textAlign(CENTER,CENTER);
    textSize(46);
    
    fill(205,25,25);
    text(text,2,2); // shadow
    fill(255,25,25);
    text(text,0,0);
  
  popMatrix();  
  
}
