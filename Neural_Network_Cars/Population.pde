import java.util.Collections; //<>//
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
  double[] normFitnesses;

  double winnerConst = 0.4;

  boolean deadPopulation = false;

  PVector[] parents;

  //int[] ----------------integer polje indeksima koji su zagarantirani winneri tj. oni koji su presli stazu
  Car[] winnerCars;
  Car[] babyCars;

  Car[] newGenCars;

  Population(int _numCars, int _popNumber) {
    populationNumber = _popNumber;
    numCars = _numCars; 
    cars = new Car[numCars];
    carGenes = new double[numCars][];
    carFitnesses = new double[numCars];
    normFitnesses = new double[numCars];

    winnerCars = new Car[numCars*2/3];
    parents = new PVector[winnerCars.length/2];
    babyCars = new Car[winnerCars.length/2];

    sw.start();
  }

  Population(Car[] newCars, int _popNumber) {
    populationNumber = _popNumber;
    numCars = newCars.length; 
    cars = newCars;
    carGenes = new double[numCars][];
    carFitnesses = new double[numCars];
    normFitnesses = new double[numCars];

    winnerCars = new Car[numCars*2/3];
    parents = new PVector[winnerCars.length/2];
    babyCars = new Car[winnerCars.length/2];

    sw.start();
  }

  void update() {
    populationDetails();
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
      if (!cars[i].isDead) {
        return false;
      }
    }
    return true;
  }


  void takeFitnesses() {
    totalFitness = 0;
    for (int i=0; i<numCars; i++) {
      totalFitness += cars[i].fitness;
      if (cars[i].fitness > maxFitness)
        maxFitness = cars[i].fitness;
    }
    for (int i=0; i<numCars; i++) {
      cars[i].normFitness = cars[i].fitness / totalFitness;
    }
  }

  void choosingWinnerCars() {  // Tournament selection metoda.
    for (int i=0; i<numCars*2/3; i++) {      
      int carA = -1;
      int carB = -1;

      // Auti mogu se mogu kvalificirati za roditelja samo ako su u top (1-winnerConst)% populacije.
      // npr. winnerConst = 0.4 -> kvalificirati se moze samo top 60% populacije (po fitnessu)
      while (carA == -1) {
        int temp = (int)random(numCars); 
        if (cars[temp].fitness / maxFitness > winnerConst)
          carA = temp;
      }
      while (carB == -1) {
        int temp = (int)random(winnerCars.length); 
        if (cars[temp].fitness / maxFitness > winnerConst)
          carB = temp;
      }

      if (cars[carA].normFitness < cars[carB].normFitness) // mogunost mijenjanja v fitness obicni
        winnerCars[i] = cars[carB];                            // onda nam ne treba takeFitnesses()
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
      double[] genes = winnerCars[i].nn.takeGenes();
      parentCars[i] = new Car(winnerCars[i].nn.mutation(genes), winnerCars[i].generation, winnerCars[i].col + (int)random(30)-15);
    }

    newGenCars = (Car[])concat(parentCars, babyCars); // U novu populaciju saljemo najbolje aute i njihove potomke.

    tempPopulation = new Population(newGenCars, populationNumber+1);
    population = tempPopulation;
  }


  void populationIsDeadIRepeatPopulationIsDead() {
    println("Generacija " + populationNumber);
    takeFitnesses();
    choosingWinnerCars();
    parentSelection();
    makingBabies();
    goingToNextGeneration();
    println("Najbolji fitness: " + (int)maxFitness);
    println("Ukupni fitness: " + (int)totalFitness); 
      output.println(populationNumber + "\t" + (int)maxFitness + "\t" + (int)totalFitness);
  }  


  void populationDetails() {
    textSize(72);
    fill(0, 102, 153);
    text(populationNumber, 20, 80);
  }
}
