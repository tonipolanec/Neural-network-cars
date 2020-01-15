Car car;
PVector start;

void setup(){
size(1280,720);
background(151);

start = new PVector(width/2,height/2);
photo = loadImage("cartemplate.png");

car = new Car(start.x,start.y);


}



void draw(){
  background(151);


  car.show();
  


}
