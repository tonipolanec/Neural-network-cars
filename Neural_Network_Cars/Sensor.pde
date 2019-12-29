float wallDist = 1000;

class Sensor{
  PVector dir;
  PVector loc;
  float x3,y3,x4,y4;
  float sensorStrength = 270;
  
  Sensor(PVector location_, PVector dir_){
    dir = dir_.get();
    loc = location_.get();
    x3 = loc.x;
    y3 = loc.y;
    
    dir.setMag(sensorStrength);
    x4 = dir.x+loc.x;
    y4 = dir.y+loc.y;
  }
  
  void show(){
  //Crtanje senzora.
      stroke(13);
      strokeWeight(0.1);
      line(0,0,dir.x,dir.y);
  }
  
  float see(){
    float tempUdaljenost = 0;
    float udaljenost = sensorStrength;
    float sjecisteX = loc.x, sjecisteY = loc.y;
    
    for(Obstacle o : obst){
      strokeWeight(5);
      
      float x1 = o.x1;
      float y1 = o.y1;
      float x2 = o.x2;
      float y2 = o.y2;
         
      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
      
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        float tempX = x1 + (uA*(x2-x1));
        float tempY = y1 + (uA*(y2-y1));      
        tempUdaljenost = dist(x3,y3,tempX,tempY);
        
        if(tempUdaljenost < udaljenost){
          udaljenost = tempUdaljenost;
          sjecisteX = tempX;
          sjecisteY = tempY;
        }

      }else if(uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1){
        udaljenost = sensorStrength;
      }
    }
    
    strokeWeight(5);
    stroke(0,0,0,100);
    line(x3,y3,sjecisteX,sjecisteY);  
    
    wallDist = udaljenost;
    return udaljenost;
    
  }
  
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
