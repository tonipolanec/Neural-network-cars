import java.math.*;


class Perceptron{
  float[] inputs, weights;
  float bias;

  
  Perceptron(float[] inputs_, float[] weights_, float bias_){
    inputs = inputs_;
    weights = weights_;
    bias = bias_;  
  }
  
  
  private float calculation(){
    float output;
    float[] xw = new float[inputs.length];
    float xwSum=0;
    
    for(int i=0; i<xw.length; i++){
      xwSum += (inputs[i] * weights[i]);  
    }
    
    output = activationF(xwSum + bias);    
    return output;
  }
  
  
  float activationF(float x){
    float value = 0;
    // f(x) = tanh(x) <-- formula funkcije
    value = (float)Math.tanh(x);
    return value;
  }
    

}
