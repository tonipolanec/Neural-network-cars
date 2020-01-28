PImage stockAuto, grayAuto;

Population population;
Population tempPopulation;

Obstacle[] obst = new Obstacle[27]; 
Checkpoint[] cp = new Checkpoint[5];

PVector startingPoint;

double mutationRate = 0.1;
int nCarsInPopulation = 60;

void setup() {
  size(1280, 720);
  background(151);
  
  startingPoint = new PVector(30, height/2);
  
  population = new Population(nCarsInPopulation,1);
    
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
  //for(Checkpoint c : cp){
   // c.show();
  //}

  population.update();
  for (Car car : population.cars) {
      if(!car.isDead)
        car.move();
      car.show();
    }
  /*
  if(!population.isPopulationDead()){
    for (Car car : population.cars) {
      car.move();
      car.show();
    }
    population.update(); 
  }else if(population.isPopulationDead()){ //<>//
    population.populationIsDeadIRepeatPopulationIsDead();
    Population temp = new Population(population.newGenCars, population.populationNumber+1);
    population = temp;
  }
*/
  
}
