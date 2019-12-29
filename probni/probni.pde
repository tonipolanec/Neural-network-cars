float vrijednost;
float unos = -0.9;

Perceptron p;

float[] in = {0.2,-0.6};
float[] we = {0.81,0.05};
float b = 0.3;
float out;
  


void setup(){
  size(400,400);
  p = new Perceptron(in,we,b);
  out = p.calculation();
  println(out);
}



void draw(){
  background(151);

  
  //textSize(20);
  text(100,100,out);


}


float activationF(float x){
    float value = 0;
    // f(x) = tanh(x) <-- formula funkcije
    value = (float)Math.tanh(x);
    return value;
  }
