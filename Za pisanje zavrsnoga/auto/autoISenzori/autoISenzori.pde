Car car;
PVector start;

void setup(){
size(1280,720);
background(151);

start = new PVector(30,height/2);

car = new Car(start.x,start.y);


}



void draw(){
  background(151);

  car.move();
  car.show();
  


}
