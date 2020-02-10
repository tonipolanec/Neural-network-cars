

Map m;
//Checkpoint[] cp = new Checkpoint[5];
//Obstacle[] obst = new Obstacle[19];

void setup(){
  size(1280,720);
  background(151);
  
  m = new Map(2);
  
  //inicijalizacijaCheckpointi();
  m.inicijalizacijaObstaclei(2); 
 
}

void draw(){

  m.showObstacles();
 //m.showCheckpoints();
  m.showFinishLine();
  
  //drawLines();
  
}
