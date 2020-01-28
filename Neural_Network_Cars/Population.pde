import java.util.Collections;
import java.util.Arrays;

class Population{
  
  Stopwatch sw = new Stopwatch();
  int populationNumber;
  
  int numCars;
  Car[] cars;
  double[][] carGenes;
  double[] carFitnesses;
  double totalFitness = 0;
  boolean deadPopulation = false;
  double[] normFitnesses;
  
  PVector[] parents;
  
  Car[] winnerCars;
  Car[] babyCars;
  
  Car[] newGenCars;
  
  Population(int _numCars, int _popNumber){
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
  
  Population(Car[] newCars, int _popNumber){
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
  
  void update(){
    populationDetails();
    deadPopulation = isPopulationDead();
    if(deadPopulation){
      deadPopulation = false;
      populationIsDeadIRepeatPopulationIsDead();
    } 
    
  }  


  void takeGenesOfCars(){
    for(int i=0;i<numCars;i++){
      carGenes[i] = cars[i].nn.takeGenes();
    }
  }
  
  boolean isPopulationDead(){
    for(int i=0;i<numCars;i++){
      if(!cars[i].isDead){
        return false;
      }
    }
    return true;    
  }
  
  
  void takeFitnesses(){
    totalFitness = 0;
    for(int i=0;i<numCars;i++){
      totalFitness += cars[i].fitness;
    }
    for(int i=0;i<numCars;i++){
      cars[i].normFitness = cars[i].fitness / totalFitness;
    }
  }
  
  void choosingWinnerCars(){  // Tournament selection metoda.
    for(int i=0;i<numCars*2/3;i++){
      int carA = (int)random(numCars);
      int carB = (int)random(numCars);
      
      if(cars[carA].normFitness < cars[carB].normFitness) // mogunost mijenjanja v fitness obicni
        winnerCars[i] = cars[carB];                            // onda nam ne treba takeFitnesses()
      else
        winnerCars[i] = cars[carA];
    }
  }
  
  void parentSelection(){
    IntList temp = new IntList();
    
    for(int i=0;i<winnerCars.length;i++){
      temp.append(i);
    }
    for(int i=0;i<winnerCars.length/2;i++){
      int x = (int)random(temp.size());
      temp.remove(x);                        // Nasumicno odredivanje 2 roditelja.      
      int y = (int)random(temp.size());
      temp.remove(y);
      parents[i] = new PVector(x,y); // postavljanje indeksi oba roditelja (x i y).

    }
  }
  
  void makingBabies(){
    
    for(int i=0;i<babyCars.length;i++){
      // Prenosenje gena iz roditelja na dijete.
      double[] parent1Genes = cars[int(parents[i].x)].nn.takeGenes();
      double[] parent2Genes = cars[int(parents[i].y)].nn.takeGenes();
      
      double[] babyGenes = new double[parent1Genes.length];  // Baby auto dobiva pol gena od jednog, a pola od drugog roditelja.
      for(int j=0;j<babyGenes.length;j++){
        if(j < babyGenes.length/2)
          babyGenes[j] = parent1Genes[j];
        else
          babyGenes[j] = parent2Genes[j];
      }
      
      // Mutacija
      for(int j=0;j<babyGenes.length;j++){
        double tempMR = random(1);
        if(tempMR < mutationRate){
          babyGenes[i] = random(-1,1);
        }
      }
      
      // Stvaranje matrica za NN dijeteta.
      double[] g1 = new double[20];
      double[] g2 = new double[12];
      double[] g3 = new double[6];
      
      int g2Br = 0;
      int g3Br = 0;
      for(int j=0;j<babyGenes.length;j++){
        if(j < 20){
          g1[j] = babyGenes[j];
        }else if(j < 32){
          g2[g2Br] = babyGenes[j];
          g2Br++;
        }else{
          g3[g3Br] = babyGenes[j];
          g3Br++;
        }
      } 
      double[][] twoD1 = oneDTo2D(g1,5,4);
      double[][] twoD2 = oneDTo2D(g2,4,3);
      double[][] twoD3 = oneDTo2D(g3,3,2);
      
      Matrix m1 = new Matrix(twoD1);
      Matrix m2 = new Matrix(twoD2);
      Matrix m3 = new Matrix(twoD3);
      
      NeuralNetwork nnBaby = new NeuralNetwork(5, 4, 3, 2, m1, m2, m3);
      babyCars[i] = new Car(nnBaby, populationNumber);
    }
    
  }

  double[][] oneDTo2D(double[] array, int rows, int cols){
    if(rows * cols == array.length){
      double[][] arrayToReturn = new double[rows][cols];
      int r = 0;
      int c = 0;
      for(int i=0;i<array.length;i++){
        if(c-cols == 0){
          c = 0;
          r++;
        }
        arrayToReturn[r][c] = array[i];
        c++;    
      }
      return arrayToReturn;
    }else{return null;}
    
  } 
  
  void goingToNextGeneration(){
   // Resetiranje autića (oni koju su umrli u prijasnjoj generaciji sada su opet zivi)
    Car[] parentCars = new Car[winnerCars.length];
    for(int i=0;i<winnerCars.length;i++){
      parentCars[i] = new Car(winnerCars[i].nn, winnerCars[i].generation);
    }
    
    newGenCars = (Car[])concat(parentCars, babyCars); // U novu populaciju saljemo najbolje aute i njihove potomke.

    tempPopulation = new Population(newGenCars, populationNumber+1); //<>//
    population = tempPopulation;
  }

  
  void populationIsDeadIRepeatPopulationIsDead(){
    takeFitnesses();
    choosingWinnerCars();
    parentSelection();
    makingBabies();
    goingToNextGeneration();
    println("Generacija " + populationNumber + " je gotova.");
  }  
  
  
  void populationDetails(){
    textSize(72);
    fill(0, 102, 153);
    text(populationNumber, 20, 80); 
  }


}
