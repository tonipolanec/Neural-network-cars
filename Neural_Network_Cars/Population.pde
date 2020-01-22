import java.util.Collections;
import java.util.Arrays;

class Population{
  
  int populationNumber;
  
  boolean stillKeepChecking;
  
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
  
  
  Population(int _numCars){
    populationNumber = 1;
    stillKeepChecking = true;
    numCars = _numCars; 
    cars = new Car[numCars];
    carGenes = new double[numCars][];
    carFitnesses = new double[numCars];
    normFitnesses = new double[numCars];
    
    winnerCars = new Car[numCars*2/3];
    parents = new PVector[winnerCars.length/2];
    babyCars = new Car[winnerCars.length/2];
  }
  
  void update(){
    if(stillKeepChecking){
      deadPopulation = isPopulationDead();
      if(deadPopulation){
        populationIsDeadIRepeatPopulationIsDead();
        stillKeepChecking = false;
      }  
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
    for(Car c : babyCars){
      c = new Car();
    }
    
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
    }
    
  }



  
  void populationIsDeadIRepeatPopulationIsDead(){
    takeFitnesses();
    choosingWinnerCars();
    parentSelection();
    makingBabies();
    println("preslo je :D");
  }  
  
  
  void populationDetails(){
    textSize(72);
    fill(0, 102, 153);
    text(""+populationNumber, 20, 80); 
  }


}
