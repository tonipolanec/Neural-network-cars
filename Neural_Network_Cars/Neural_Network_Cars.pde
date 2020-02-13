
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

double mutationRate = 0.08;
int nCarsInPopulation = 60;

int pop = 0;

int backgroundColorGray = 151;

color c;

int programFlow;

void setup() {
  size(1280, 720, P2D); // Za bolje performanse dodati ", P2D"
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



void draw() {
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



void keyPressed() {
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

void mousePressed() {
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
