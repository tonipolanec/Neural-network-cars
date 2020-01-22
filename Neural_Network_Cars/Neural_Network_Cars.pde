PImage stockAuto, grayAuto;

Population population = new Population(21);

Obstacle[] obst = new Obstacle[27]; 
Checkpoint[] cp = new Checkpoint[6];

double mutationRate = 0.01;

void setup() {
  size(1280, 720);
  background(151);

  stockAuto = loadImage("cartemplate2.png");    //
  grayAuto = loadImage("graycar2.png");         // PNG fileovi za auteke.  


  for (int i=0; i<population.cars.length; i++) {
    population.cars[i] = new Car();
  }
  
  
  inicijalizacijaCheckpointi(); // Checkpoint tab.
  inicijalizacijaObstaclei();   // Obstacle tab.
}



void draw() {
  background(151);
  //pisiPoEkranu(); // U Car tabu

  for (Obstacle o : obst) {
    o.show();
  }
  

  for (Car car : population.cars) {
    car.move();
    car.show();
  }
  
  population.update();
  population.populationDetails();
  
}
