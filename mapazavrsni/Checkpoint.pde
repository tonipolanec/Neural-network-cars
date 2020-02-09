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
    //fill(0,0,0);
    //ellipse(location.x,location.y,3,3);
        
    noStroke();
    fill(0,200,0,105);
    ellipse(location.x,location.y,radius,radius);

  
  }

}
