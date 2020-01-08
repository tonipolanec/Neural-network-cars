import java.math.*;


class Perceptron{
  float[] inputs, weights;
  float bias;

  
  Perceptron(float[] inputs_, float[] weights_, float bias_){
    arrayCopy(inputs_, inputs);
    arrayCopy(weights_, weights);
    bias = bias_;  
  }
  
  
  float calculation(){  //racunanje izlaza jednog perceptrona
    float output;
    float[] xw = new float[inputs.length];
    float xwSum=0;
    
    for(int i=0; i<xw.length; i++){
      xwSum += (inputs[i] * weights[i]);  
    }
    
    output = activationF(xwSum + bias);    
    return output;
  }
  
  
  float activationF(float x){ //funkcija koja "ugladuje" izlaz
    float value = 0;
    // f(x) = tanh(x) <-- formula funkcije
    value = (float)Math.tanh(x);
    return value;
  }
    

}
