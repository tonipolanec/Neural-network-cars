PImage carImage = new PImage(); 

int flag = 0;

float x = 0, y = 0;

FloatList obstacles = new FloatList();

Float[] startKoor = new Float[2];

FloatList checkpoints = new FloatList();
float checkMultiplier = 1;

Float[] finishLine = new Float[4];

PrintWriter obst, start, check, finish;

String trenutno = "Starting point";

void setup() {
  size(1280, 720);
  background(151);
  
  carImage = loadImage("data/cartemplate.png");

  obst = createWriter("obstacles.txt");
  start = createWriter("startingpoint.txt");
  check = createWriter("checkpoints.txt");
  finish = createWriter("finishline.txt");
}


void draw() {
  background(151);
  
  //--------------------------Instructions for building map------------------
  textAlign(LEFT, CENTER);
  
  fill(95);
  textSize(21);
  
  if(trenutno == "Starting point"){
    text("Cars need to start from left pointing right.", 270, 45);
    text("Please place the starting point somewhere in the gray rectangle.", 270, 68);
      
    rectMode(CORNER);
    fill(130);
    noStroke();    
    rect(10, 90, 250, 620, 10);
 
  }else if(trenutno == "Walls"){
    text("Press 'space' if you want to 'lift' the pencil", 270, 45);
    
  }else if(trenutno == "Checkpoints"){
    text("Order of placing is important. Place them along the track (from start to finish).", 270, 45);
    text("It's recommended to put them after sharper corners.", 270, 68);
    text("No need for more than 3-4.", 270, 91);
    
  }else if(trenutno == "Finish line"){
    text("They must be able to access it.", 270, 45);
    text("Presumably at the end of the track.", 270, 68);
  }

  fill(100);
  textSize(20);
  text("q - starting point", 10, 15);
  text("w - walls/obstacles", 10, 35);
  text("e - checkpoints", 10, 55);
  text("r - finish line", 10, 75);

  fill(70);
  textSize(30);
  text(trenutno, 270, 15);
  
  textAlign(RIGHT, CENTER);
  fill(70);
  textSize(21);
  text("ENTER - finish map", 1270, 675);
  text("backspace - reset map", 1270, 700);

  //--------------------------Drawing of the created map---------------------

  for (int i=0; i< obstacles.size(); i+=4) {
    stroke(0);
    strokeWeight(2);
    line(obstacles.get(i), obstacles.get(i+1), obstacles.get(i+2), obstacles.get(i+3));
  }

  if (startKoor[0] != null) {
    pushMatrix();
    translate(startKoor[0], startKoor[1]);
    rotate(PI/2);
    imageMode(CENTER);
    image(carImage, 0, 0);
    popMatrix();
  }

  for (int i = 0; i< checkpoints.size(); i+=2) {
    ellipseMode(RADIUS);
    stroke(0, 200, 0, 100);
    fill(0, 200, 0, 100);
    ellipse(checkpoints.get(i), checkpoints.get(i+1), 85, 85);
  }

  if (finishLine[3] != null) {
    stroke(200, 200, 0);
    strokeWeight(4);
    line(finishLine[0], finishLine[1], finishLine[2], finishLine[3]);
  }

}



void mousePressed() {

  // Actual functions for creating map

  switch(flag) {

  case 0:
    start = createWriter("startingpoint.txt");
  
    startKoor[0] = (float)mouseX;
    startKoor[1] = (float)mouseY;

    start.println(mouseX + "," + mouseY);
    break;

  case 1:   
    if (x == 0 && y == 0) {
      x = mouseX;
      y = mouseY;
    } else {
      obstacles.append(x);
      obstacles.append(y);
      obstacles.append(mouseX);
      obstacles.append(mouseY);

      obst.println(x + "," + y + "," + mouseX + "," + mouseY);

      x = mouseX;
      y = mouseY;
    }
    break;

  case 2:
    checkMultiplier += 0.25;
    checkpoints.append(mouseX);
    checkpoints.append(mouseY);

    check.println(mouseX + "," + mouseY + ", 170," + checkMultiplier);

    break;
  case 3:
    finish = createWriter("finishline.txt");

    if (x == 0 && y == 0) {
      x = mouseX;
      y = mouseY;
    } else {
      finishLine[0] = x;
      finishLine[1] = y;
      finishLine[2] = (float)mouseX;
      finishLine[3] = (float)mouseY;   

      finish.println(x + "," + y + "," + mouseX + "," + mouseY);
    }
    break;
  }
}

void keyPressed() {
  if (key == ' ') {
    x = 0;
    y = 0;
  }
  if (key == ENTER) {
    obst.flush();
    obst.close();

    start.flush();
    start.close();

    finish.println("0,0");
    finish.flush();
    finish.close();

    check.flush();
    check.close();
    exit();
  }

  if (key == 'q') {
    flag = 0; // Slaze se za starting point
    start = createWriter("startingpoint.txt");
    x = 0;
    y = 0;
    trenutno = "Starting point";
  } else if (key == 'w') {
    flag = 1; // Slazu se zidovi
    x = 0;
    y = 0;
    trenutno = "Walls";
  } else if (key == 'e') {
    flag = 2; // Slazu se checkpointi
    check = createWriter("checkpoints.txt");
    x = 0;
    y = 0;
    checkMultiplier = 1;
    trenutno = "Checkpoints";
  } else if (key == 'r') {
    flag = 3; // Slaze se finishline
    finish = createWriter("finishline.txt");
    x = 0;
    y = 0;
    trenutno = "Finish line";
  }else if(key == BACKSPACE){
    resetMapCreator();
  }
}

// Sve ponovno inicijalizirati (resetirati)
void resetMapCreator() { 
  flag = 0;
  x = 0;
  y = 0;
  obstacles = new FloatList();
  startKoor = new Float[2];
  checkpoints = new FloatList();
  checkMultiplier = 1;
  finishLine = new Float[4];
  obst = createWriter("obstacles.txt");
  start = createWriter("startingpoint.txt");
  check = createWriter("checkpoints.txt");
  finish = createWriter("finishline.txt");
  trenutno = "Starting point";
}
