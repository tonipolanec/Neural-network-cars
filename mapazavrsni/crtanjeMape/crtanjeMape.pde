
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

  obst = createWriter("obstacles.txt");
  start = createWriter("startingpoint.txt");
  check = createWriter("checkpoints.txt");
  finish = createWriter("finishline.txt");
}


void draw() {
  background(151);
  drawLines();


  for (int i=0; i< obstacles.size(); i+=4) {
    stroke(0);
    strokeWeight(2);
    line(obstacles.get(i), obstacles.get(i+1), obstacles.get(i+2), obstacles.get(i+3));
  }
  
  if(startKoor[0] != null){
    fill(255,25,25);
    textAlign(CENTER,CENTER);
    textSize(20);
    text("start", startKoor[0], startKoor[1]);
  }
  
  for(int i = 0; i< checkpoints.size(); i+=2){
    ellipseMode(RADIUS);
    stroke(0,200,0,100);
    fill(0,200,0,100);
    ellipse(checkpoints.get(i),checkpoints.get(i+1), 80, 80);
  }
  
  if(finishLine[3] != null){
    stroke(200,200,0);
    strokeWeight(4);
    line(finishLine[0],finishLine[1],finishLine[2],finishLine[3]);
  }
  
  fill(100);
  textSize(30);
  textAlign(CENTER,CENTER);
  text(trenutno, width/3*2, 15);
}



void mousePressed() {

  //ZA CRTANJE STAZE 

  if (x == 0 && y == 0) {
    x = mouseX;
    y = mouseY;
  } else {

    switch(flag) {

    case 0:
      startKoor[0] = (float)mouseX;
      startKoor[1] = (float)mouseY;
      
      start.println(mouseX + "," + mouseY);
      break;

    case 1:   
      obstacles.append(x);
      obstacles.append(y);
      obstacles.append(mouseX);
      obstacles.append(mouseY);

      obst.println(x + "," + y + "," + mouseX + "," + mouseY);

      x = mouseX;
      y = mouseY;
      break;

    case 2:
      checkMultiplier += 0.25;
      checkpoints.append(mouseX);
      checkpoints.append(mouseY);
      
      check.println(mouseX + "," + mouseY + ", 160," + checkMultiplier);

      break;
    case 3:
      finishLine[0] = x;
      finishLine[1] = y;
      finishLine[2] = (float)mouseX;
      finishLine[3] = (float)mouseY;
    
      
      finish.println(x + "," + y + "," + mouseX + "," + mouseY);

      break;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    x = 0;
    y = 0;
  }
  if (key == 'i') {
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
  }
}




void drawLines() {

  stroke(0, 0, 255);
  strokeWeight(3);

  /*
  line( 0,280,180,280 );
   line( 0,440,300,440 );
   line( 180,280,350,200 );
   line( 300,440,390,320 );
   line( 350,200,500,200 );
   line( 390,320,600,320 );
   line( 500,200,600,100 );
   line( 600,320,700,230 );
   line( 600,100,900,100 );
   line( 700,230,800,230 );
   line( 900,100,930,130 );
   line( 800,230,800,330 );
   line( 930,130,930,440 );
   line( 930,440,850,480 );
   line( 800,330,640,450 );
   line( 640,450,640,550 );
   line( 640,550,760,680 );
   line( 850,480,850,530 );
   line( 760,680,1150,680 );
   line( 850,530,1000,530 );
   line( 1000,530,1100,450 );
   line( 1150,680,1200,600 );
   line( 1200,600,1200,100 );
   line( 1100,450,1100,100 );
   line( 1100,100,1050,40 );
   line( 1200,100,1250,40 );
   line( 1050,0,1050,40 );
   line( 1250,0,1250,40 );
   line( 0,280,0,440 );
   */

  // ZA GRAF
  //line(0,465,570,465);
  //line(570,465,570,720);
}
