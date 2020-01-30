PImage stockAuto, grayAuto, finishLine;

Population population;
Population tempPopulation;

Obstacle[] obst = new Obstacle[28]; 
Checkpoint[] cp = new Checkpoint[5];

PVector startingPoint;

double mutationRate = 0.1;
int nCarsInPopulation = 45;

int pop = 0;

void setup() {
  size(1280, 720);
  background(151);
  
  startingPoint = new PVector(30, height/2);
  
  population = new Population(nCarsInPopulation,1);
    
  stockAuto = loadImage("cartemplate.png");    //  PNG fileovi za auteke.
  grayAuto = loadImage("graycar.png");         //   
  finishLine = loadImage("finishline.png");    // PNG za finish line.
  
  for (int i=0; i<population.cars.length; i++) {
    population.cars[i] = new Car();
  }   

  inicijalizacijaCheckpointi(); // Checkpoint tab.
  inicijalizacijaObstaclei();   // Obstacle tab.
}



void draw() {
  background(151);
  //pisiPoEkranu(); // U Car tabu
  
  imageMode(CORNER);
  image(finishLine, 1050, 0);

  for (Obstacle o : obst) {
    o.show();
  }
  //for(Checkpoint c : cp){
  //  c.show();
  //}


  population.update();
  for (Car car : population.cars) { 
      if(!car.isDead)  // Ako je auto udario u zid više mu se ne 
        car.move();    // izračunavaju parametri (efikasniji program)
     car.show();
  } //<>//
  
}
