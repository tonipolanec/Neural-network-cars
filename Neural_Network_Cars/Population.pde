

class Population{
  
  int numCars;
  Car[] cars;
  double[][] carGenes;
  double[] carFitnesses;
  double totalFitness = 0;
  
  Population(int _numCars){
    numCars = _numCars; 
    cars = new Car[numCars];
    carGenes = new double[numCars][];
  }


  void takeGenesOfCars(){
    for(int i=0;i<numCars;i++){
      carGenes[i] = cars[i].nn.takeGenes();
    }
  }
  
  void takeFitnesses(){
    for(int i=0;i<numCars;i++){
      carFitnesses[i] = cars[i].fitness;
      totalFitness += cars[i].fitness;
    }
  }



  
  


}
