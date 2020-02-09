
class Map{
  
  Obstacle[] obstacles;
  Checkpoint[] checkpoints;
  FinishLine finishLine;

  Map(int indexOfAMap){
    obstacles = inicijalizacijaObstaclei(indexOfAMap);
    checkpoints = inicijalizacijaCheckpointi(indexOfAMap);
    finishLine = inicijalizacijaFinishLinea(indexOfAMap);
  }


  Obstacle[] inicijalizacijaObstaclei(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/obstacles.txt");
    Obstacle[] obst = new Obstacle[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      obst[i] = new Obstacle(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return obst;
  }

  Checkpoint[] inicijalizacijaCheckpointi(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/checkpoints.txt");
    Checkpoint[] cp = new Checkpoint[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",3);
   
      cp[i] = new Checkpoint(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]));
    }
    return cp;
  }

  FinishLine inicijalizacijaFinishLinea(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/finishline.txt");
    FinishLine fl;
    String[] nums = lines[0].split(",",4);
   
    fl = new FinishLine(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    
    return fl;
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
  
  Obstacle(PVector start, PVector end){
    x1 = start.x;
    y1 = start.y;
    //vector = end.get();
  }
  Obstacle(float x1_, float y1_, float x2_, float y2_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }
  
  void show(){
    stroke(0,0,255);
    strokeWeight(3);
    //line(x1,y1,vector.x,vector.y);
    line(x1,y1,x2,y2);
  }
}

class Checkpoint{
  
  PVector location;
  float radius;
  boolean passed;

    Checkpoint(float x,float y, float r){
      location = new PVector(x,y);
      radius = r;    
      passed = false;
    }

  void show(){
    noStroke();
    fill(0,200,0,105);
    ellipse(location.x,location.y,radius,radius);
  }
}

class FinishLine {
  float x1, y1, x2, y2;

  FinishLine(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }

  void show() {
    stroke(255, 242, 0);
    strokeWeight(3);
    line(x1, y1, x2, y2);
  }
}
