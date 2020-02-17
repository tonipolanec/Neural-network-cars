import java.util.Collections;
import java.util.Arrays;

class Population {

  Stopwatch sw = new Stopwatch();
  int populationNumber;

  int numCars;
  Car[] cars;
  double[][] carGenes;
  double[] carFitnesses;
  double totalFitness = 0;
  double maxFitness = 0;
  double avgSpeed = 0;
  double maxAvgSpeed = 0;
  double minAvgSpeed = 10;
  double[] normFitnesses;

  double winnerConst = 0.2;

  boolean deadPopulation = false;
  int alive;
  boolean infiniteLoop = false;

  PVector[] parents;

  IntList guaranteedWinnerCars;
  Car[] winnerCars;
  Car[] babyCars;

  Car[] newGenCars;
  
  int plenkiNumber = -1;

  Population(int _numCars, int _popNumber) {
    populationNumber = _popNumber;
    numCars = _numCars; 
    alive = numCars;
    cars = new Car[numCars];
    carGenes = new double[numCars][];
    carFitnesses = new double[numCars];
    normFitnesses = new double[numCars];

    winnerCars = new Car[numCars*2/3];
    guaranteedWinnerCars = new IntList();
    parents = new PVector[winnerCars.length/2];
    babyCars = new Car[winnerCars.length/2];

    sw.start();
  }

  Population(Car[] newCars, int _popNumber) {
    populationNumber = _popNumber;
    numCars = newCars.length; 
    alive = numCars;
    cars = newCars;
    carGenes = new double[numCars][];
    carFitnesses = new double[numCars];
    normFitnesses = new double[numCars];

    winnerCars = new Car[numCars*2/3];
    guaranteedWinnerCars = new IntList();
    parents = new PVector[winnerCars.length/2];
    babyCars = new Car[winnerCars.length/2];

    sw.start();
  }

  void update() {
    populationDetails();
    alive = numCars;
    for (int i=0; i<cars.length; i++) {
      if (guaranteedWinnerCars.size() < numCars/3)
        if (cars[i].finished)
          guaranteedWinnerCars.append(i);
      if(cars[i].isDead && !cars[i].finished)
        alive--;
    }
    if (isPopulationDead()) {
      deadPopulation = true;
      populationIsDeadIRepeatPopulationIsDead();
    }
  }  


  void takeGenesOfCars() {
    for (int i=0; i<numCars; i++) {
      carGenes[i] = cars[i].nn.takeGenes();
    }
  }

  boolean isPopulationDead() {
    for (int i=0; i<numCars; i++) {
      if (!cars[i].isDead && !cars[i].finished) {
        return false;
      }
    }
    return true;
  }

  void takeAvgSpeed() {
    float allSpeeds = 0;
    maxAvgSpeed = 0;
    minAvgSpeed = 10;
    for (Car c : cars) {
      allSpeeds += c.avgSpeed;

      if(c.finished){
        if (c.avgSpeed > maxAvgSpeed)
          maxAvgSpeed = c.avgSpeed;
        if (c.avgSpeed < minAvgSpeed)
          minAvgSpeed = c.avgSpeed;
      }
    }
    avgSpeed = allSpeeds / numCars;
  }


  void takeFitnesses() {
    int bestCarIndex = 0;
    /*
    // Dodatno povecanje fitnesa ovisno o brzini (1x - 1.3x)
    for (int i=0; i<numCars; i++) {
      if(cars[i].finished){
        if(cars[i].fitness == minAvgSpeed)
          cars[i].fitness *= 1;
        else if(cars[i].fitness == maxAvgSpeed)
          cars[i].fitness *= 1.3;
        else
          cars[i].fitness *= map((float)cars[i].avgSpeed, (float)minAvgSpeed, (float)maxAvgSpeed, 1, 1.3);             
      }
    }
    */
    totalFitness = 0;
    for (int i=0; i<numCars; i++) {
      totalFitness += cars[i].fitness;
      if (cars[i].fitness > maxFitness){
        maxFitness = cars[i].fitness;
        bestCarIndex = i;
      }
    }
    cars[bestCarIndex].bestCar = true;
    guaranteedWinnerCars.append(bestCarIndex);
    for (int i=0; i<numCars; i++) {
      cars[i].normFitness = cars[i].fitness / totalFitness; /// moguce zameniti z maxFitnesom
    }
    sviUkupniFitnessi.append((float)population.totalFitness);
    sviBrojeviGeneracija.append((float)population.populationNumber);
  }

  void choosingWinnerCars() {  // Tournament selection metoda.
    for (int i=0; i<guaranteedWinnerCars.size(); i++) {
      winnerCars[i] = cars[guaranteedWinnerCars.get(i)];
    }
    
    // Uzima 2 slucajna auta te odabire bolji. (Tournament metoda odabiranja roditelja) 
    for (int i=guaranteedWinnerCars.size(); i<numCars*2/3; i++) {      
      int carA = -1;
      int carB = -1;
      
      // Auti se mogu kvalificirati za roditelja samo ako su u top (1-winnerConst)% populacije.
      // npr. winnerConst = 0.4 -> kvalificirati se moze samo top 60% populacije (po fitnessu)
      while (carA == -1) {
        int temp = (int)random(numCars); 
        if (cars[temp].fitness / maxFitness > winnerConst)
          carA = temp;                                          
      }   
      
      while (carB == -1) {
        int temp = (int)random(numCars); 
        if (cars[temp].fitness / maxFitness > winnerConst)
          carB = temp;
      }

      // Odabirenje boljega od 2 odabrana auta.
      if (cars[carA].fitness < cars[carB].fitness)
        winnerCars[i] = cars[carB];                                                        
      else
        winnerCars[i] = cars[carA];
    }
  }

  void parentSelection() {
    IntList temp = new IntList();

    for (int i=0; i<winnerCars.length; i++) {
      temp.append(i);
    }
    for (int i=0; i<winnerCars.length/2; i++) {
      int x = (int)random(temp.size());
      temp.remove(x);                        // Nasumicno odredivanje 2 roditelja.      
      int y = (int)random(temp.size());
      temp.remove(y);
      parents[i] = new PVector(x, y); // postavljanje indeksi oba roditelja (x i y).
    }
  }

  void makingBabies() {
    // Mijenjanje staze
    m = changeMap;

    for (int i=0; i<babyCars.length; i++) {
      // Prenosenje gena iz roditelja na dijete.
      double[] parent1Genes = cars[int(parents[i].x)].nn.takeGenes();
      double[] parent2Genes = cars[int(parents[i].y)].nn.takeGenes();

      int babyColor = ( (cars[int(parents[i].x)].col + cars[int(parents[i].y)].col) /2 )  + (int)random(10)-5; 

      double[] babyGenes = new double[parent1Genes.length];  // Baby auto dobiva pol gena od jednog, a pola od drugog roditelja.
      for (int j=0; j<babyGenes.length; j++) {
        if (j < babyGenes.length/2)
          babyGenes[j] = parent1Genes[j];
        else
          babyGenes[j] = parent2Genes[j];
      }

      NeuralNetwork nnBaby = cars[i].nn.mutation(babyGenes);

      babyCars[i] = new Car(nnBaby, populationNumber, babyColor);
    }
  }



  void goingToNextGeneration() {

    // Resetiranje autića (oni koju su umrli u prijasnjoj generaciji sada su opet zivi)
    Car[] parentCars = new Car[winnerCars.length];
    for (int i=0; i<winnerCars.length; i++) {
      if(!winnerCars[i].bestCar){
        double[] genes = winnerCars[i].nn.takeGenes();
        parentCars[i] = new Car(winnerCars[i].nn.mutation(genes), winnerCars[i].generation, winnerCars[i].col + (int)random(30)-15);
      }else{
        parentCars[i] = new Car(winnerCars[i].nn, winnerCars[i].generation, winnerCars[i].col);
      }
    }

    newGenCars = (Car[])concat(parentCars, babyCars); // U novu populaciju saljemo najbolje aute i njihove potomke.

    tempPopulation = new Population(newGenCars, populationNumber+1);
    population = tempPopulation; 
    
    resetCuzPlenki(); // Resetira na plenkuNumber-ti generaciji.
    
  }
  
  void makeThemDead(){
    for (int i=0; i<numCars; i++) {
      if(!cars[i].finished)
        cars[i].isDead = true;
    }
  }


  void populationIsDeadIRepeatPopulationIsDead() {
    println("Generacija " + populationNumber + " je gotova.");
    takeAvgSpeed();
    takeFitnesses();
    choosingWinnerCars();
    parentSelection();
    makingBabies();
    goingToNextGeneration();

    //println("Najbolji fitness: " + (int)maxFitness);
    //println("Ukupni fitness: " + (int)totalFitness); 
    //println("Average speed: " + avgSpeed); 
  }
  
  
  
  void plenkiNumber(int a){
    plenkiNumber = a;
  }
    
  void resetCuzPlenki(){
    if(populationNumber == plenkiNumber){
      // Resetira se cijela populacija. Kreće se od nule s potpuo novim autićima.
      resetAll();
    }
  
  }

  void resetAll(){
    Population tempPopulation = new Population(nCarsInPopulation, 1);
    population = tempPopulation;
   
    for (int i=0; i<population.cars.length; i++) {
      population.cars[i] = new Car();
    }
  }

  void populationDetails() {
    fill(backgroundColorGray);
    stroke(backgroundColorGray);
    if(populationNumber < 10){
      rect(20,8,50,60);
      rect(70,43,100,25);
    }else{
      rect(20,8,95,60);
      rect(70,43,140,25);
    }
    textAlign(LEFT, BOTTOM);
    textSize(72);
    fill(c);
    text(populationNumber, 20, 80);
    
    
    textSize(22);
    //fill(0, 102, 153);
    if(populationNumber < 10)
      text("alive: " + alive, 75, 68);
    else  
      text("alive: " + alive, 115, 68);
    textSize(24);
    //fill(0, 102, 153);
    text(sw.second(), width/2, 30);
    
    if(sw.second() > 29) // Postavlja flag da autici voze vec 30 sekundi
      infiniteLoop = true; // te da su mozda u infinite loop-u.
    if(infiniteLoop){
      textAlign(LEFT, CENTER);
      fill(90);
      textSize(20);
      text("Press 'd' if they are in infinite loop.", 700, 12);
    }
      
  }
}
