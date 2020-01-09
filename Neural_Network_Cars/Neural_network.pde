import Jama.*;
import Jama.examples.*;
import Jama.test.*;
import Jama.util.*;

class NeuralNetwork{

    int nInput, nHidden1, nHidden2, nOutput;
  
    Matrix input,iToH1,h1ToH2,h2ToO; // Matrice weightova.
    //Matrix h1B, h2B, oB;  // Matrice bias-eva pojedinih perceptrona.
    //Perceptron[] h1,h2,o;
    Matrix output;
    
    NeuralNetwork(int _nInput, int _nHidden1, int _nHidden2, int _nOutput){
      nInput = _nInput;
      input = new Matrix(nInput,1);
      nHidden1 = _nHidden1;
      nHidden2 = _nHidden2;
      nOutput = _nOutput;
      output = new Matrix(nOutput, 1);
      
      double[][] tempArray = new double[nInput][nHidden1];    //
      iToH1 = new Matrix(randomValuesMatrice(tempArray));     // 
                                                              //    
      tempArray = new double[nHidden1][nHidden2];             // Kreiranje matrica za weight-e    
      h1ToH2 = new Matrix(randomValuesMatrice(tempArray));    // (veze izmedu perceptrona)
                                                              //
      tempArray = new double[nHidden2][nOutput];              //
      h2ToO = new Matrix(randomValuesMatrice(tempArray));     //
      
    }
       
    
    
    void feedForward(double[] inputs){
      input = new Matrix(inputs,1);
      output = input.copy();
      output = output.times(iToH1).copy();
      output = output.times(h1ToH2).copy();
      output = output.times(h2ToO).copy();
      
      double[][] outputArray = output.getArray();
      for(int i=0;i<outputArray.length;i++){
        for(int j=0;j<outputArray[0].length;j++){
          print(outputArray[i][j] + " ");
        }
        println("");
      }

    }

    
    
    double[][] randomValuesMatrice(double[][] mat){
      for(int i=0;i<mat.length;i++){
        for(int j=0;j<mat[0].length;j++){
          mat[i][j] = random(-1,1);
        }
      }
      return mat;
    }

}
