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
