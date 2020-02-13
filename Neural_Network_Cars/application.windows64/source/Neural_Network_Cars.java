import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import Jama.*; 
import Jama.examples.*; 
import Jama.test.*; 
import Jama.util.*; 
import java.util.Collections; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Neural_Network_Cars extends PApplet {


PImage stockAuto, grayAuto, glowingAuto, finishLine;
PImage[] tracks;

Population population;
Population tempPopulation;

Obstacle[] obst;
FinishLine finish;
Checkpoint[] cp = new Checkpoint[5];

Map[] maps = new Map[4];
Map changeMap;
Map m;         // Trenutna mapa

RadioButton[][] radioButtons = new RadioButton[2][]; // Buttons za biranje tijekom simulacije.
Button[] buttonsForTrackSelection = new Button[4]; // Button za biranje prije pocetka.

FloatList sviUkupniFitnessi = new FloatList();
FloatList sviBrojeviGeneracija = new FloatList();

PVector startingPoint;

double mutationRate = 0.08f;
int nCarsInPopulation = 60;

int pop = 0;

int backgroundColorGray = 151;

int c;

int programFlow;

public void setup() {
   // Za bolje performanse dodati ", P2D"
  //fullScreen();
  background(backgroundColorGray);

  programFlow = 0;

  c = color(0, 35, 250);

  population = new Population(nCarsInPopulation, 1);

  for (int i=0; i<maps.length; i++) {
    maps[i] = new Map(i);
  }
  m = null;
  changeMap = null;

  radioButtons[0] = new RadioButton[4];
  radioButtons[0][0] = new RadioButton(270, 0, 60, 40, "1", 0, 0);
  radioButtons[0][1] = new RadioButton(333, 0, 60, 40, "2", 0, 1);
  radioButtons[0][2] = new RadioButton(396, 0, 60, 40, "3", 0, 2);
  radioButtons[0][3] = new RadioButton(459, 0, 60, 40, "4", 0, 3);


  stockAuto = loadImage("img/cartemplate.png");    //  PNG fileovi za auteke.
  grayAuto = loadImage("img/graycar.png");         //   
  glowingAuto = loadImage("img/glowingcar.png");         //
  finishLine = loadImage("img/finishline.png");    // PNG za finish line.

  tracks = new PImage[4];
  for (int i=0; i< tracks.length; i++) {  // PNG slike za odabir staze
    tracks[i] = loadImage("maps/"+ i +"/staza.png");
  }  
}



public void draw() {
  background(151);

  switch(programFlow) {
  case 0: 
    textAlign(CENTER, TOP);
    
    fill(0, 20, 150);                             //
    textSize(50);                                 //
    text("Neural Network Cars", width/2+2, 2);    //  Shadow of a text
    textSize(28);                                 //
    text("Choose starting track", width/2+2, 59); //
    
    fill(c);
    textSize(50);
    text("Neural Network Cars", width/2, 0);
    textSize(28);
    text("Choose starting track", width/2, 58);

    fill(120);
    stroke(100);
    strokeWeight(10);


    buttonsForTrackSelection[0] = new Button(133, 130, 446, 260, "", 0);
    buttonsForTrackSelection[1] = new Button(701, 130, 446, 260, "", 1);
    buttonsForTrackSelection[2] = new Button(133, 425, 446, 260, "", 2);
    buttonsForTrackSelection[3] = new Button(701, 425, 446, 260, "", 3);

    imageMode(CORNER);

    rect(133, 130, 446, 260);          
    image(tracks[0], 143, 140);
    rect(701, 130, 446, 260);
    image(tracks[1], 711, 140);

    rect(133, 425, 446, 260);
    image(tracks[2], 143, 435);
    rect(701, 425, 446, 260);
    image(tracks[3], 711, 435);
    
    showDifficulty(133,130, "Easy");
    showDifficulty(701,130, "Normal");
    showDifficulty(133,420, "Hard");
    showDifficulty(701,425, "Random");

    if (m != null) {
      // Velike buttone disable-amo jer kreće simulacija
      for(Button b : buttonsForTrackSelection){ 
        b.enabled = false;
      }
      
      for (int i=0; i<population.cars.length; i++) {
        population.cars[i] = new Car();
      }
      radioButtons[0][m.index].chosen = true;
      population.sw.start();
      programFlow++;
    }

    break;

  case 1: 

    m.showObstacles();
    //m.showCheckpoints();

    m.showFinishLine();

    

    population.plenkiNumber(10);  // Resetiranje populacije na n-ti generaciji 


    population.update();
    for (Car car : population.cars) { 
      if (!car.isDead)  // Ako je auto udario u zid više mu se ne 
        car.move();    // izračunavaju parametri (efikasniji program)
      car.show();
    }

    for (Button b : radioButtons[0]) {
      b.show();
    }


    textSize(22);
    fill((255-backgroundColorGray));
    text((int)frameRate, width-40, height-15);  // Ispis fps-a.

    break;



  default:
    textAlign(CENTER, CENTER);
    text("Please press ENTER to restart simulation.", width/2, height/2);
    break;
  }
}



public void keyPressed() {
  if (key == '1') { 
    changeMap = maps[0];
    radioButtons[0][0].setActive();
  } else if (key == '2') { 
    changeMap = maps[1];
    radioButtons[0][1].setActive();
  } else if (key == '3') { 
    changeMap = maps[2];
    radioButtons[0][2].setActive();
  } else if (key == '4') { 
    changeMap = maps[3];
    radioButtons[0][3].setActive();
    
  } else if (key == ENTER) {
    if (programFlow > 1){
      programFlow = 0;
      population.resetAll();
      for (RadioButton b : radioButtons[0]) {
        b.reset();
      }
      m = null;
    }else{
      programFlow++;
    }
  }
}

public void mousePressed() {
  println(mouseX+ "," + mouseY);

  for (RadioButton b : radioButtons[0]) {
    b.clicked();
    b.action();
  }

  for (Button b : buttonsForTrackSelection) {
    b.clicked();
  }

  //println(changeMap.index);
}

class Button {

  boolean enabled;

  int id;

  float x, y, w, h;
  String text = "";

  Button(float _x, float _y, float _w, float _h, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    id = _id;
    enabled = true;
  }

  Button(float _x, float _y, float _w, float _h, String _text, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    id = _id;
    enabled = true;
  }


  public void clicked() {

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      if (enabled)
        action();
    }
  }

  public void show() {

    rectMode(CORNER);
    fill(131);
    stroke(101);
    strokeWeight(3);
    rect(x, y, w, h);

    fill(0);
    textSize(22);
    textAlign(CENTER, CENTER);
    text(text, x+(w/2), y+(h/2)-2);

    textAlign(LEFT, BOTTOM);
  }

  public void action() {

    switch(id) { // Ucini bilo sto ovisno o id-u buttona,
      // svaki switch case je kao onClicked funkcija.
    case 0: 
      m = maps[0];
      changeMap = m;
      //programFlow++;
      break;
    case 1: 
      m = maps[1];
      changeMap = m;
      //programFlow++;
      break;
    case 2: 
      m = maps[2];
      changeMap = m;
      //programFlow++;
      break;
    case 3: 
      m = maps[3];
      changeMap = m;
      //programFlow++;
      break;
    default:
      break;
    }
  }
}

class RadioButton extends Button {

  int radioId;
  boolean chosen = false;

  RadioButton(float _x, float _y, float _w, float _h, int _radioId, int _id) {
    super(_x, _y, _w, _h, _id);
    radioId = _radioId;
  }

  RadioButton(float _x, float _y, float _w, float _h, String _text, int _radioId, int _id) {
    super(_x, _y, _w, _h, _text, _id);
    radioId = _radioId;
  }

  public void clicked() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      //boolean currentState = chosen;

      for (RadioButton b : radioButtons[radioId]) {
        b.chosen = false;
      }
      //chosen = !currentState; // Moguce "ugasiti" button
      chosen = true;
    }
  }

  public void show() {

    if (chosen) {  // Ako je odabran onda je rub zuti
      rectMode(CORNER);
      fill(145);
      stroke(255, 220, 0);
      strokeWeight(3);
      rect(x, y, w, h);

      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);
    } else {
      rectMode(CORNER);
      fill(131);
      stroke(101);
      strokeWeight(3);
      rect(x, y, w, h);

      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);
    }
    textAlign(LEFT, BOTTOM);
  }

  public void setActive() {
    for (RadioButton b : radioButtons[radioId]) {
      b.chosen = false;
    }
    chosen = true;
  }

  public void action() {
    if (radioButtons[radioId][id].chosen) {
      switch(id) {
      case 0: 
        changeMap = maps[0];
        break;
      case 1: 
        changeMap = maps[1];
        break;
      case 2: 
        changeMap = maps[2];
        break;
      case 3: 
        changeMap = maps[3];
        break;
      default:
        break;
      }
    }
  }
  public void reset() {
    for (RadioButton b : radioButtons[radioId]) {
      b.chosen = false;
    }
  }
}

PVector start;

class Car {
  NeuralNetwork nn;

  int generation;

  PVector start;

  PVector loc, vel, acc;
  float radius;

  float fitness;
  float fitnessMultiplier;
  double normFitness;

  //double percFitness; // Percentage ukupnog fitnessa od svih u populaciji.

  float distTravelled;

  Sensor f, fr, fl, r, l;
  float frontS, frontRightS, frontLeftS, rightS, leftS;

  PImage carImage;
  PImage finishedCarImage;

  //int step = 0;
  double[] steeringSpeed = new double[2]; //prvi element je steering, drugi brzina
  float topSpeed;
  FloatList speedsForAvg;
  float avgSpeed = 0;

  double wallDist;
  boolean isDead;
  boolean finished;
  boolean bestCar = false;

  int col; // color of the car
  Car() {
    nn = new NeuralNetwork(5, 4, 3, 2);

    generation = 1;
    start = startingPoint;
    loc = new PVector(m.startingPoint.x, m.startingPoint.y);
    acc = new PVector(0.1f, 0);
    vel = new PVector();
    isDead = false;
    finished = false;
    radius = 20; 
    steeringSpeed[0] = 0;
    steeringSpeed[1] = 0;
    topSpeed = 4;
    speedsForAvg = new FloatList();

    col = (int)random(255);
    carImage = coloringCar(stockAuto.copy(), col);
    finishedCarImage = coloringCar(glowingAuto.copy(), col);

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 1;
  }

  Car(NeuralNetwork _nn, int _gen, int _col) {
    nn = _nn;

    generation = _gen;
    start = startingPoint;
    loc = new PVector(m.startingPoint.x, m.startingPoint.y);
    acc = new PVector(0.1f, 0);
    vel = new PVector();
    isDead = false;
    finished = false;
    radius = 20; 
    steeringSpeed[0] = 0;
    steeringSpeed[1] = 0;
    topSpeed = 4;
    speedsForAvg = new FloatList();

    col = _col;
    carImage = coloringCar(stockAuto.copy(), col);
    finishedCarImage = coloringCar(glowingAuto.copy(), col);

    distTravelled = 0;
    fitness = 0;
    fitnessMultiplier = 1;
  }

  public void move() {

    if (!isDead && !finished) {
      update(); //Brzina i skretanje se postavljaju.

      vel.add(acc);
      loc.add(vel);
      distTravelled+= vel.copy().mag();

      //Inicijalizacija senzora. (Kutevi:  0.349rad = 20deg, 0.873 = 50deg)   
      PVector norm = vel.copy().normalize();
      f = new Sensor(loc, norm);                        //
      fr = new Sensor(loc, norm.copy().rotate(0.349f));   // (0.349 rad = 20 stupnjeva)
      fl = new Sensor(loc, norm.copy().rotate(-0.349f));  // Inicijalizacija i crtanje senzora.
      r = new Sensor(loc, norm.copy().rotate(0.873f));    // (0.873 rad = 50 stupnjeva)
      l = new Sensor(loc, norm.copy().rotate(-0.873f));   //

      float[] wallDists = new float[5];

      if (f.seeFinish(m.finishLine) < 30) {
        finished = true;
        isDead = false;
      }

      frontS = f.see();  
      wallDists[0] = frontS;           
      frontRightS = fr.see();    
      wallDists[1] = frontRightS;       
      frontLeftS = fl.see();     
      wallDists[2] = frontLeftS;  // Omogucavanje senzorima da "vide" te dodavanje distance od svakog senzora u polje
      leftS = l.see();           
      wallDists[3] = leftS;             
      rightS = r.see();          
      wallDists[4] = rightS;  

      float minWD = wallDists[4];
      for (int i=0; i<wallDists.length-1; i++) {
        if (wallDists[i] < minWD)
          minWD = wallDists[i]; // Postavljanje najmanjeg distance-a za provjeravanje je li auto udario u zid.
      }
      wallDist = minWD; 
      isDead();

      int sec = population.sw.second();
      //println(sec);
      if (fitnessMultiplier < 1.25f && sec > 15) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 1.5f && sec > 30) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 1.75f && sec > 45) {
        isDead = true;
        fitness = 1;
      } else if (fitnessMultiplier < 2 && sec > 60) {
        isDead = true;
        fitness = 1;
      }
    }
  }

  public void show() {
    float theta = vel.heading() + PI/2;   //Kut okretanja crteža auta.
    fill(210);
    noStroke();

    pushMatrix();
    translate(loc.x, loc.y);    

    //Crtanje senzornih zraka.
    //showSensors();

    // Crtanje autića.    
    rotate(theta);

    imageMode(CENTER);
    if (finished) {
      image(finishedCarImage, 0, 0);
    } else if (isDead) {
      image(grayAuto, 0, 0);
    } else {
      //tint(255, 255, 255, 156); 
      image(carImage, 0, 0);
    }

    if (isDead && avgSpeed == 0) {
      float allSpeeds = 0;
      for (int i=0; i< speedsForAvg.size(); i++) {
        allSpeeds += speedsForAvg.get(i);
      }
      avgSpeed = allSpeeds/(speedsForAvg.size());
    }


    // Ispis podataka svakog autica.
    textSize(12);
    fill(0, 0, 0);
    //text(fitnessMultiplier,15,15);
    //text(generation,15,15);


    popMatrix();
  }


  public void isDead() {      //Ispituje dali je auto udario u zid (ako je; "umire")
    //zid staze     
    if (wallDist <= 20) {
      isDead = true;
    } else {
      //zid prozora
      if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) {
        isDead = true;
      } else {
        isDead = false;
      }
    }
  }



  public void update() {

    double[] inputsForNN = {rightS, frontRightS, frontS, frontLeftS, leftS}; // Postavljanje value-i od senzori u input polje za NN.
    steeringSpeed = nn.feedForward(inputsForNN);  // Uzimanje outputa NN-a u polje steering-a i speed-a.

    //Utjecanje na skretanje auta. (-1 -> lijevo; 1 -> desno)
    float steeringAngle = map((float)steeringSpeed[0], -1, 1, -0.05f, 0.05f);
    acc.rotate(steeringAngle); 

    //Postavljanje limita na brzinu, tj. izravno utjecanje na brzinu auta.
    float speed = map((float)steeringSpeed[1], -1, 1, 1, 3);
    if ((float)steeringSpeed[1] > 1) {
      vel.limit(topSpeed);
    } else if ((float)steeringSpeed[1] < -1) {
      vel.limit(0);
    } else {
      vel.limit(speed);
    } 

    speedsForAvg.append((float)speed);

    checkpointDetection();
    fitness = distTravelled * fitnessMultiplier;
  }



  public void checkpointDetection() {      // Provjerava je li auto došao do checkpointa te
    // postavlja fitness multiplier ovisno o tome.
    textSize(24);
    fill(0);
    stroke(255, 0, 0);
    for (Checkpoint c : m.checkpoints) {
      if (dist(loc.x, loc.y, c.location.x, c.location.y) < c.radius/2) { 
        fitnessMultiplier = c.multiplier;   // Ako auto dođe do checkpointa tada se postavlja određeni multiplier.
        c.passed = true;
      } 
    }
  }

  // Crtanje senzornih zraka
  public void showSensors() {
    if (!isDead) {
      f.show();
      fr.show();
      fl.show();
      r.show();
      l.show();
    }
  }

  public PImage coloringCar(PImage carImage, int col) {
    carImage.loadPixels();
    int dimensionsPic = carImage.height * carImage.width;
    for (int i=0; i<dimensionsPic; i++) {
      if (carImage.pixels[i] == color(0, 0, 0)) {
        colorMode(HSB);
        carImage.pixels[i] = color(col, 255, 255);
        colorMode(RGB);
      }
    }
    return carImage;
  }


  public void pisiPoEkranu() {
    textSize(24);
    fill(0);
    text("l: " + leftS, 10, 590); 
    text("fl: " + frontLeftS, 10, 620); 
    text("f: " + frontS, 10, 650); 
    text("fr: " + frontRightS, 10, 680); 
    text("r: " + rightS, 10, 710);
  }
}

class Map{
  
  int index;
  
  Obstacle[] obstacles;
  Checkpoint[] checkpoints;
  FinishLine finishLine;
  PVector startingPoint;

  Map(int indexOfAMap){
    index = indexOfAMap;
    
    obstacles = inicijalizacijaObstaclei();
    checkpoints = inicijalizacijaCheckpointi();
    finishLine = inicijalizacijaFinishLinea();
    startingPoint = inicijalizacijaStartingPointa();


  }


  public Obstacle[] inicijalizacijaObstaclei(){
    String[] lines = loadStrings("maps/" + index + "/obstacles.txt");
    Obstacle[] obst = new Obstacle[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      obst[i] = new Obstacle(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return obst;
  }

  public Checkpoint[] inicijalizacijaCheckpointi(){
    String[] lines = loadStrings("maps/" + index + "/checkpoints.txt");
    Checkpoint[] cp = new Checkpoint[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      cp[i] = new Checkpoint(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return cp;
  }

  public FinishLine inicijalizacijaFinishLinea(){
    String[] lines = loadStrings("maps/" + index + "/finishline.txt");
    FinishLine fl;
    String[] nums = lines[0].split(",",4);
    String[] slika = lines[1].split(",",2);
   
    fl = new FinishLine(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]), Float.parseFloat(slika[0]), Float.parseFloat(slika[1]));
    
    return fl;
  }
  
  public PVector inicijalizacijaStartingPointa(){
    String[] lines = loadStrings("maps/" + index + "/startingpoint.txt");
    PVector sp;
    String[] nums = lines[0].split(",",2);
   
    sp = new PVector(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]));
    
    return sp;
  }


  public void showObstacles(){   
    for(Obstacle o : obstacles){
      o.show();
    }  
  }

  public void showCheckpoints(){   
    for(Checkpoint c : checkpoints){
      c.show();
    }  
  }
  
  public void showFinishLine(){
    finishLine.show();
  }


}

class Obstacle{
  float x1,y1,x2,y2;
  
  /*Obstacle(PVector start, PVector end){
    x1 = start.x;
    y1 = start.y;
    //vector = end.get();
  }
  */
  Obstacle(float x1_, float y1_, float x2_, float y2_){
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }
  
  public void show(){
    stroke(c);
    strokeWeight(5);
    //line(x1,y1,vector.x,vector.y);
    line(x1,y1,x2,y2);
  }
}

class Checkpoint{
  
  PVector location;
  float radius;
  boolean passed;
  float multiplier;

    Checkpoint(float x,float y, float r, float _multiplier){
      location = new PVector(x,y);
      radius = r;    
      passed = false;
      multiplier = _multiplier;
    }

  public void show(){
    noStroke();
    fill(0,200,0,105);
    ellipse(location.x,location.y,radius,radius);
  }
}

class FinishLine {
  float x1, y1, x2, y2;
  
  //Za sliku finish line-a.
  float sx1, sy1;

  FinishLine(float _x1, float _y1, float _x2, float _y2, float _sx1, float _sy1) {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    
    sx1 = x1 + _sx1;
    sy1 = y1 + _sy1;

  }

  public void show() {
    stroke(255, 242, 0);
    strokeWeight(3);
    line(x1, y1, x2, y2);
    
    if(m.index != 3){
      imageMode(CORNER);
      image(finishLine, m.finishLine.sx1, m.finishLine.sy1);
    }
  }
  
}

public void showDifficulty(int x, int y, String text){
  pushMatrix();
    translate(x+20,y+20);
    rotate(-PI/5);
    textAlign(CENTER,CENTER);
    textSize(46);
    
    fill(205,25,25);
    text(text,2,2); // shadow
    fill(255,25,25);
    text(text,0,0);
  
  popMatrix();  
  
}





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



  public double[] feedForward(double[] inputs) {
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



  public double[][] randomValuesMatrice(double[][] mat) {
    for (int i=0; i<mat.length; i++) {
      for (int j=0; j<mat[0].length; j++) {
        mat[i][j] = random(2) -1;
      }
    }
    return mat;
  }

  public Matrix activationF(Matrix a) {   //funkcija koja "ugladuje" elemente matrice [-1,1]
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


  public double[] takeGenes() {
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

  public NeuralNetwork mutation(double[] genes) {

    // Mutacija
    for (int i=0; i<genes.length; i++) {
      double tempMR = random(1);
      if (tempMR < mutationRate) {
        genes[i] = random(-0.5f, 0.5f);
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

  public double[] twoDToOneD(double[][] ar2) {
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

  public double[][] oneDTo2D(double[] array, int rows, int cols) {
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

  double winnerConst = 0.2f;

  boolean deadPopulation = false;
  int alive;

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

  public void update() {
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


  public void takeGenesOfCars() {
    for (int i=0; i<numCars; i++) {
      carGenes[i] = cars[i].nn.takeGenes();
    }
  }

  public boolean isPopulationDead() {
    for (int i=0; i<numCars; i++) {
      if (!cars[i].isDead && !cars[i].finished) {
        return false;
      }
    }
    return true;
  }

  public void takeAvgSpeed() {
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


  public void takeFitnesses() {
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

  public void choosingWinnerCars() {  // Tournament selection metoda.
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

  public void parentSelection() {
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

  public void makingBabies() {
    // Mijenjanje staze
    m = changeMap;

    for (int i=0; i<babyCars.length; i++) {
      // Prenosenje gena iz roditelja na dijete.
      double[] parent1Genes = cars[PApplet.parseInt(parents[i].x)].nn.takeGenes();
      double[] parent2Genes = cars[PApplet.parseInt(parents[i].y)].nn.takeGenes();

      int babyColor = ( (cars[PApplet.parseInt(parents[i].x)].col + cars[PApplet.parseInt(parents[i].y)].col) /2 )  + (int)random(10)-5; 

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



  public void goingToNextGeneration() {

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


  public void populationIsDeadIRepeatPopulationIsDead() {
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
  
  
  
  public void plenkiNumber(int a){
    plenkiNumber = a;
  }
    
  public void resetCuzPlenki(){
    if(populationNumber == plenkiNumber){
      // Resetira se cijela populacija. Kreće se od nule s potpuo novim autićima.
      resetAll();
    }
  
  }

  public void resetAll(){
    Population tempPopulation = new Population(nCarsInPopulation, 1);
    population = tempPopulation;
   
    for (int i=0; i<population.cars.length; i++) {
      population.cars[i] = new Car();
    }
  }

  public void populationDetails() {
    fill(backgroundColorGray);
    stroke(backgroundColorGray);
    if(populationNumber < 10){
      rect(20,8,50,60);
      rect(70,43,100,25);
    }else{
      rect(20,8,95,60);
      rect(70,43,140,25);
    }
    
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
  }
}

class Sensor {
  PVector dir;
  PVector loc;
  float x3, y3, x4, y4;
  float sensorStrength = 300;

  Sensor(PVector location_, PVector dir_) {
    dir = dir_.copy();
    loc = location_.copy();
    x3 = loc.x;
    y3 = loc.y;

    dir.setMag(sensorStrength);
    x4 = dir.x+loc.x;
    y4 = dir.y+loc.y;
  }

  public void show() {
    //Crtanje senzora.
    stroke(255-backgroundColorGray);
    strokeWeight(1);
    line(0,0,dir.x,dir.y);
  }


  public float see() {
    float tempUdaljenost = 0;
    float udaljenost = sensorStrength;
    float sjecisteX = loc.x, sjecisteY = loc.y;

    for (Obstacle o : m.obstacles) {

      float x1 = o.x1;
      float y1 = o.y1;
      float x2 = o.x2;
      float y2 = o.y2;

      float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //Matematicki izracun za dobivanje tocke
      float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //do koje pojedini senzor "vidi".

      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        float tempX = x1 + (uA*(x2-x1));
        float tempY = y1 + (uA*(y2-y1));      
        tempUdaljenost = dist(x3, y3, tempX, tempY);

        if (tempUdaljenost < udaljenost) {
          udaljenost = tempUdaljenost;
          sjecisteX = tempX;    // Pronalazenje do koje tocke 
          sjecisteY = tempY;    // senzor vidi (ne vidi dalje od zida).
        }
      } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {
        udaljenost = sensorStrength;
      }
    }

    strokeWeight(2);
    stroke(255, 230, 0, 55);
    //line(x3,y3,sjecisteX,sjecisteY);   // Podebljavanje dio senzora koji oznacuje vidno polje. 

    return udaljenost;     // Vraca udaljenost od zida. BITNO!!
  }
  
  public float seeFinish(FinishLine fl) {
    float tempUdaljenost = 0;
    float udaljenost = sensorStrength;
    float sjecisteX = loc.x, sjecisteY = loc.y;

    float x1 = fl.x1;
    float y1 = fl.y1;
    float x2 = fl.x2;
    float y2 = fl.y2;

    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //Matematicki izracun za dobivanje tocke
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));  //do koje pojedini senzor "vidi".

    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      float tempX = x1 + (uA*(x2-x1));
      float tempY = y1 + (uA*(y2-y1));      
      tempUdaljenost = dist(x3, y3, tempX, tempY);

      if (tempUdaljenost < udaljenost) {
        udaljenost = tempUdaljenost;
        sjecisteX = tempX;    // Pronalazenje do koje tocke 
        sjecisteY = tempY;    // senzor vidi (ne vidi dalje od zida).
      }
    } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {
      udaljenost = sensorStrength;
    }
   

    strokeWeight(3);
    stroke(0, 255, 0);
    //line(x3,y3,sjecisteX,sjecisteY);   // Podebljavanje dio senzora koji oznacuje vidno polje. 

    return udaljenost;     // Vraca udaljenost od zida. BITNO!!
  }
}



class Stopwatch {
  int startTime = 0, stopTime = 0;
  boolean running = false;  

  public void start() {
    startTime = millis();
    running = true;
  }
  public void stop() {
    stopTime = millis();
    running = false;
  }
  public int getElapsedTime() {
    int elapsed;
    if (running) {
      elapsed = (millis() - startTime);
    } else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  public int second() {
    return (getElapsedTime() / 1000) % 60;
  }
}
  public void settings() {  size(1280, 720, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Neural_Network_Cars" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
