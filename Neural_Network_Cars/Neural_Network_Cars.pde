
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

PrintWriter output;

color c;

int programFlow;
//                                                                               BUG KOD MIJENJANJA MAPE
void setup() {
  size(1280, 720, P2D); // Za bolje performanse dodati ", P2D"
  //fullScreen();
  background(backgroundColorGray);

  programFlow = 0;

  output = createWriter("fitness.txt");
  output.println("Generacija" + "\t" + "Najbolji_fitness" + "\t" + "Ukupni_fitness");

  c = color(0, 35, 250);

  population = new Population(nCarsInPopulation, 1);

  for (int i=0; i<maps.length; i++) {
    maps[i] = new Map(i);
  }
  m = maps[2];
  changeMap = m;

  radioButtons[0] = new RadioButton[4];
  radioButtons[0][0] = new RadioButton(270, 0, 60, 40, "1", 0, 0);
  radioButtons[0][1] = new RadioButton(333, 0, 60, 40, "2", 0, 1);
  radioButtons[0][2] = new RadioButton(396, 0, 60, 40, "3", 0, 2);
  radioButtons[0][3] = new RadioButton(459, 0, 60, 40, "4", 0, 3);

  radioButtons[0][m.index].chosen = true;


  stockAuto = loadImage("img/cartemplate.png");    //  PNG fileovi za auteke.
  grayAuto = loadImage("img/graycar.png");         //   
  glowingAuto = loadImage("img/glowingcar.png");         //
  finishLine = loadImage("img/finishline.png");    // PNG za finish line.

  tracks = new PImage[4];
  for (int i=0; i< tracks.length; i++) {  // PNG slike za odabir staze
    tracks[i] = loadImage("maps/"+ i +"/staza.png");
  }  
  //stats = createGraphics(600,235);

  for (int i=0; i<population.cars.length; i++) {
    population.cars[i] = new Car();
  }
}



void draw() {
  background(151);

  switch(programFlow) {
  case 0: 
    fill(c);
    textSize(50);
    textAlign(CENTER, TOP);
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



    population.sw.start();

  break;

  case 1: 

    m.showObstacles();
    //m.showCheckpoints();

    imageMode(CORNER);
    image(finishLine, m.finishLine.sx1, m.finishLine.sy1);
    //m.showFinishLine();

    //population.plenkiFunction(2);  // Resetiranje populacije na n-ti generaciji 

    if (m.showGraph) {
      if (population.populationNumber > 4 && population.plenkiNumber == -1) {
        imageMode(CORNER);  
        updateStats(sviBrojeviGeneracija.array(), sviUkupniFitnessi.array());
        //showGraph();
      }
    }


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
  if (key == 'i') {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit(); // Stops the program
  } else if (key == '0') { 
    changeMap = maps[0];
  } else if (key == '1') { 
    changeMap = maps[1];
  } else if (key == '2') { 
    changeMap = maps[2];
  } else if (key == '3') { 
    changeMap = maps[3];
  } else if (key == ENTER) {
    if (programFlow > 1)
      programFlow = 0;
    else
      programFlow++;
  }
}

void mousePressed() {
  //println(mouseX+ "," + mouseY);

  for (Button b : radioButtons[0]) {
    b.clicked();
    b.action();
  }

  for (Button b : buttonsForTrackSelection) {
    //b.chosen = true;
    //b.action();
  }

  //println(changeMap.index);
}
