Car car;
PVector cl,cv;
Obstacle[] obst = new Obstacle[27]; 
Checkpoint[] cp = new Checkpoint[5];
PVector start;

void setup(){
size(1280,720);
background(151);

start = new PVector(30,height/2);

car = new Car(start.x,start.y);


inicijalizacijaCheckpointi(); // Checkpoint tab.
inicijalizacijaObstaclei();   // Obstacle tab.

}



void draw(){
  background(151);
  pisiPoEkranu(); // Sensor tab.
  
  for(Obstacle o : obst){
    o.show();
  }
  for(Checkpoint c : cp){
    c.show();
  }
  
  car.move();
  car.show();
  


}

//KONTROLE -------------Privremeno (dok jos nema NN)
     
     void keyPressed() {
      if (key == 'i') {
        car.speed +=0.1;
      } else if (key == 'k') {
        car.speed-=0.1;
      }else if(key == 'j'){
        car.steering -= 0.01;
      }else if(key == 'l'){
        car.steering += 0.01;
      }
    } 
