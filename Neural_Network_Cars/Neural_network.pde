import Jama.*;
import Jama.examples.*;
import Jama.test.*;
import Jama.util.*;

class NeuralNetwork {

  int nInput, nHidden1, nHidden2, nOutput;

  Matrix input, iToH1, h1ToH2, h2ToO; // Matrice weightova.
  //Matrix h1B, h2B, oB;  // Matrice bias-eva pojedinih perceptrona.
  //Perceptron[] h1,h2,o;
  Matrix output;

  NeuralNetwork(int _nInput, int _nHidden1, int _nHidden2, int _nOutput) {
    nInput = _nInput;
    input = new Matrix(nInput, 1);
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

  NeuralNetwork(int _nInput, int _nHidden1, int _nHidden2, int _nOutput, Matrix m1, Matrix m2, Matrix m3) {
    nInput = _nInput;
    input = new Matrix(nInput, 1);
    nHidden1 = _nHidden1;
    nHidden2 = _nHidden2;
    nOutput = _nOutput;
    output = new Matrix(nOutput, 1);

    iToH1 = m1;     // 
    h1ToH2 = m2;    // (veze izmedu perceptrona dobivene mutacijom i crossoverom roditelja)
    h2ToO = m3;     //
  }



  double[] feedForward(double[] inputs) {
    input = new Matrix(inputs, 1);
    output = input.copy();
    output = activationF(output.times(iToH1).copy());
    output = activationF(output.times(h1ToH2).copy());
    output = activationF(output.times(h2ToO).copy());

    double[][] temp2DA = output.getArray();

    /*//ispis outputa radi debugginga--------------
     for(int i=0;i<temp2DA.length;i++){
     for(int j=0;j<temp2DA[0].length;j++){
     print(temp2DA[i][j] + " ");
     }
     println("");
     }
     //-------------------------------------------
     */
    //outputArray[0][0], outputArray[0][1]
    double[] out = {temp2DA[0][0], temp2DA[0][1]};
    return out;
  }



  double[][] randomValuesMatrice(double[][] mat) {
    for (int i=0; i<mat.length; i++) {
      for (int j=0; j<mat[0].length; j++) {
        mat[i][j] = random(-1, 1); //------------------------TREBA SE JOS IGRATI (ako se vrti v krug -> BAD)
      }
    }
    return mat;
  }

  Matrix activationF(Matrix a) {   //funkcija koja "ugladuje" elemente matrice [-1,1]
    double[][] tempArrayOfMatrix = a.getArray();
    double[][] outArray = new double[tempArrayOfMatrix.length][tempArrayOfMatrix[0].length];

    for (int i=0; i<tempArrayOfMatrix.length; i++) {
      for (int j=0; j<tempArrayOfMatrix[0].length; j++) {
        outArray[i][j] = Math.tanh(tempArrayOfMatrix[i][j]);
      }
    }
    // value = (float)Math.tanh(x);
    // f(x) = tanh(x) <-- formula funkcije
    Matrix outMatrix = new Matrix(outArray);
    return outMatrix;
  }


  double[] takeGenes() {
    // iToH1, h1ToH2, h2ToO <-- matrice iz kojih uzimamo gene
    double[][] ar2D1 = this.iToH1.getArrayCopy();
    double[][] ar2D2 = this.h1ToH2.getArrayCopy();
    double[][] ar2D3 = this.h2ToO.getArrayCopy();

    double[] ar1 = twoDToOneD(ar2D1);
    double[] ar2 = twoDToOneD(ar2D2);
    double[] ar3 = twoDToOneD(ar2D3);

    double[] genes = (double[])concat((double[])concat(ar1, ar2), ar3);
    return genes;
  }

  NeuralNetwork mutation(double[] genes) {

    // Mutacija
    for (int i=0; i<genes.length; i++) {
      double tempMR = random(1);
      if (tempMR < mutationRate) {
        genes[i] = random(-0.5, 0.5);
      }
    }

    // Stvaranje matrica za novi NN.
    double[] g1 = new double[20];
    double[] g2 = new double[12];
    double[] g3 = new double[6];

    int g2Br = 0;
    int g3Br = 0;
    for (int i=0; i<genes.length; i++) {
      if (i < 20) {
        g1[i] = genes[i];
      } else if (i < 32) {
        g2[g2Br] = genes[i];
        g2Br++;
      } else {
        g3[g3Br] = genes[i];
        g3Br++;
      }
    } 
    double[][] twoD1 = oneDTo2D(g1, 5, 4);
    double[][] twoD2 = oneDTo2D(g2, 4, 3);
    double[][] twoD3 = oneDTo2D(g3, 3, 2);

    Matrix m1 = new Matrix(twoD1);
    Matrix m2 = new Matrix(twoD2);
    Matrix m3 = new Matrix(twoD3);


    NeuralNetwork nn = new NeuralNetwork(5, 4, 3, 2, m1, m2, m3);
    return nn;
  }

  double[] twoDToOneD(double[][] ar2) {
    double[] outArray = new double[ar2.length * ar2[0].length];
    int index = 0;

    for (int i=0; i<ar2.length; i++) {
      for (int j=0; j<ar2[0].length; j++) {
        outArray[index] = ar2[i][j];
        index++;
      }
    }
    return outArray;
  }

  double[][] oneDTo2D(double[] array, int rows, int cols) {
    if (rows * cols == array.length) {
      double[][] arrayToReturn = new double[rows][cols];
      int r = 0;
      int c = 0;
      for (int i=0; i<array.length; i++) {
        if (c-cols == 0) {
          c = 0;
          r++;
        }
        arrayToReturn[r][c] = array[i];
        c++;
      }
      return arrayToReturn;
    } else {
      return null;
    }
  }
}
