boolean novaMapa = false; //<>//

PImage stockAuto, grayAuto, glowingAuto, finishLine;

Population population;
Population tempPopulation;

Obstacle[] obst;
FinishLine finish;
Checkpoint[] cp = new Checkpoint[5];

Map[] maps = new Map[4];
Map changeMap;
Map m;         // Trenutna mapa

FloatList sviUkupniFitnessi = new FloatList();
FloatList sviBrojeviGeneracija = new FloatList();

PVector startingPoint;

double mutationRate = 0.08;
int nCarsInPopulation = 60;

int pop = 0;

int backgroundColorGray = 151;

PrintWriter output;

void setup() {
  size(1280, 720, P2D); // Za bolje performanse dodati ", P2D"
  //fullScreen();
  background(backgroundColorGray);

  output = createWriter("fitness.txt");
  output.println("Generacija" + "\t" + "Najbolji_fitness" + "\t" + "Ukupni_fitness");
  
  for(int i=0; i<maps.length;i++){
    maps[i] = new Map(i);  
  }
  m = maps[0];
  changeMap = m;
  

  population = new Population(nCarsInPopulation, 1);

  stockAuto = loadImage("img/cartemplate.png");    //  PNG fileovi za auteke.
  grayAuto = loadImage("img/graycar.png");         //   
  glowingAuto = loadImage("img/glowingcar.png");         //
  finishLine = loadImage("img/finishline.png");    // PNG za finish line.
  
  //stats = createGraphics(600,235);

  for (int i=0; i<population.cars.length; i++) {
    population.cars[i] = new Car();
  }   

  //inicijalizacijaCheckpointi(); // Checkpoint tab.
  //inicijalizacijaObstaclei();   // Obstacle tab.
}



void draw() {
  background(backgroundColorGray);
  
  imageMode(CORNER);
  image(finishLine, m.finishLine.x1, m.finishLine.y1);

  m.showObstacles();
  //m.showCheckpoints();
  
  
  if(population.populationNumber > 4){
    imageMode(CORNER);  
    updateStats(sviBrojeviGeneracija.array(),sviUkupniFitnessi.array());
    showStats();
  }

  population.update();
  for (Car car : population.cars) { 
    if (!car.isDead)  // Ako je auto udario u zid više mu se ne 
      car.move();    // izračunavaju parametri (efikasniji program)
    car.show();
  }
  

  textSize(22);
  fill((255-backgroundColorGray));
  text((int)frameRate, width-40, height-15);  // Ispis fps-a.
}



void keyPressed() {
  if(key == 'i'){
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit(); // Stops the program
  }else if(key == '0'){ 
    changeMap = maps[0];
  }else if(key == '1'){ 
    changeMap = maps[1];
  }else if(key == '2'){ 
    changeMap = maps[2];
  }else if(key == '3'){ 
    changeMap = maps[3];
  }
  
}
