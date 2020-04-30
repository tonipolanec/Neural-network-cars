
PImage stockAuto, grayAuto, glowingAuto, finishLine, startingCar;
PImage[] tracksImages;

Population population;
Population tempPopulation;

Obstacle[] obst;
FinishLine finish;
Checkpoint[] cp = new Checkpoint[5];

MapCreator mapCreator = new MapCreator();

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

String carType = "2"; // "1" for classic, "2" for modern

//int pop = 0;

int backgroundColorGray = 151;
color back = color(204,204,255);

color c;

int programFlow;
int changeProgramFlow;

void setup() {
  size(1280, 720, P2D); // Za bolje performanse dodati ", P2D"
  background(backgroundColorGray);
  

  programFlow = 0;

  population = new Population(nCarsInPopulation, 1);

  mapCreator.createWriters();
  for (int i=0; i<maps.length-1; i++) {
    maps[i] = new Map(i);
  }
  m = null;
  changeMap = null;

  radioButtons[0] = new RadioButton[4];
  radioButtons[0][0] = new RadioButton(270, 0, 60, 40, "1", 0, 0);
  radioButtons[0][1] = new RadioButton(333, 0, 60, 40, "2", 0, 1);
  radioButtons[0][2] = new RadioButton(396, 0, 60, 40, "3", 0, 2);
  radioButtons[0][3] = new RadioButton(459, 0, 60, 40, "4", 0, 3);


  stockAuto = loadImage("data/img/cartype/"+carType+"/cartemplate.png");    //  PNG fileovi za auteke.
  grayAuto = loadImage("data/img/cartype/"+carType+"/graycar.png");         //   
  glowingAuto = loadImage("data/img/cartype/"+carType+"/glowingcar.png");   //
  startingCar = loadImage("data/img/cartype/"+carType+"/startingcar.png");  //

  finishLine = loadImage("data/img/finishline.png");    // PNG za finish line.

  c = color(0, 35, 250);
  tracksImages = new PImage[4];
  for (int i=0; i< tracksImages.length; i++) {  // PNG slike za odabir staze
    tracksImages[i] = loadImage("data/maps/"+ i +"/staza.png");
  }
}



void draw() {
  background(backgroundColorGray);

  switch(programFlow) {              // programFlow : 0 - početni zaslon (odabiranje prve staze)
  case 0:                            //               1 - kreator staza
                                     //               2 - glavna simulacija
    showTitle();                     //         default - zaslon za resetiranje programa (povratak na 0)
    showButtonsForTrackSelection();


    if (m != null) { // Ako je odabrana neka staza.
      // Velike buttone disable-amo jer kreće simulacija
      for (Button b : buttonsForTrackSelection) { 
        b.enabled = false;
      }
      if (m.index != 3) {      
        for (int i=0; i<population.cars.length; i++) {
          population.cars[i] = new Car();
        }
        radioButtons[0][m.index].chosen = true;
        population.sw.start();

        programFlow = 2;
      }
    }

    break;

  case 1: 

    mapCreator.drawCreator();

    break;

  case 2: 

    population.printPopulationDetails();

    m.showStartingPoint();
    m.showObstacles();
    //m.showCheckpoints();
    m.showFinishLine();

    population.update();
    for (Car car : population.cars) { 
      if (!car.isDead)  // Ako je auto udario u zid više mu se ne 
        car.move();    // izračunavaju parametri (efikasniji program)
      car.show();
    }

    showButtons();

    break;



  default:
    textAlign(CENTER, CENTER);
    textSize(22);
    fill(60);
    text("Please press ENTER to restart simulation.", width/2, height/2);
    break;
  }

}



void keyPressed() {

  if (programFlow == 1) {  // Ako je u map creatoru.
    mapCreator.keyPress();
  } else if (programFlow > 1) {  // Ako je u simulaciji.
    if (key == 'd') {
      population.makeThemDead();
    } else if (key == ENTER) {
      if (programFlow > 2) {
        programFlow = 0;
        population.resetAll();
        for (RadioButton b : radioButtons[0]) {
          b.reset();
        }
        m = null;
        mapCreator.resetMapCreator();
      } else {
        programFlow++;
      }
    }
  }
}

void mousePressed() {
  //println(mouseX+ "," + mouseY);

  if (programFlow == 1) {  // Ako je u map creatoru.
    mapCreator.mousePress();
  } else {

    for (RadioButton b : radioButtons[0]) {
      b.clicked();
      b.action();
    }

    for (Button b : buttonsForTrackSelection) {
      b.clicked();
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (programFlow == 1) {
    if (mapCreator.trenutno == "Checkpoints") {
      float scroll = -event.getCount() * 5;
      mapCreator.checkRadius += scroll;
    }
  }
}
