PImage stockAuto, grayAuto;

Car cars[] = new Car[20];
Obstacle[] obst = new Obstacle[27]; 
Checkpoint[] cp = new Checkpoint[6];


void setup(){
size(1280,720);
background(151);

stockAuto = loadImage("cartemplate.png");    //
grayAuto = loadImage("graycar.png");         // PNG fileovi za auteke.  


for(int i=0;i<cars.length;i++){
  cars[i] = new Car();
}

inicijalizacijaCheckpointi(); // Checkpoint tab.
inicijalizacijaObstaclei();   // Obstacle tab.

}



void draw(){
  background(151);
  //pisiPoEkranu(); // U Car tabu
  
  for(Obstacle o : obst){
    o.show();
  }
  for(Checkpoint c : cp){
    c.show();
  }
  
  for(Car car : cars){
    car.move();
    car.show();
  }
  


}

//KONTROLE -------------Privremeno (dok jos nema NN)
     /*
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
    */
