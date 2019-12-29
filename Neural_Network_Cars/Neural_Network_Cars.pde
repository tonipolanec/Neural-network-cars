Car c,c1,c2;
PVector cl,cv;
Obstacle[] obst = new Obstacle[27]; 
Checkpoint[] cp = new Checkpoint[5];
PVector start;

void setup(){
size(1280,720);
background(151);

start = new PVector(30,height/2);

c = new Car(start.x,start.y);


inicijalizacijaCheckpointi(); // U Checkpoint tabu.
inicijalizacijaObstaclei();   // U Obstacle tabu.

}



void draw(){
  background(151);
  pisiPoEkranu(); // U Sensor tabu.
  
  for(Obstacle o : obst){
    o.show();
  }
  for(Checkpoint c : cp){
    c.show();
  }
  
  c.move();
  c.show();
  


}

//KONTROLE -------------
     
     void keyPressed() {
      if (key == 'i') {
        c.speed +=0.1;
      } else if (key == 'k') {
        c.speed-=0.1;
      }else if(key == 'j'){
        c.steering -= 0.01;
      }else if(key == 'l'){
        c.steering += 0.01;
      }
    } 
