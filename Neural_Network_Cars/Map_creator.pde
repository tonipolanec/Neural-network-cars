

class MapCreator {

  int flag = 0;

  float x = 0, y = 0;

  FloatList obstaclesKoor = new FloatList();

  Float[] startKoor = new Float[2];

  FloatList checkpointsKoor = new FloatList();
  float checkMultiplier = 1;

  Float[] finishLineKoor = new Float[4];

  PrintWriter obstacleWriter, startWriter, checkpointWriter, finishWriter;

  String trenutno = "Starting point";

  MapCreator() {
  }


  void createWriters() {
    obstacleWriter = createWriter("data/maps/3/obstacles.txt");
    startWriter = createWriter("data/maps/3/startingpoint.txt");
    checkpointWriter = createWriter("data/maps/3/checkpoints.txt");
    finishWriter = createWriter("data/maps/3/finishline.txt");
  }

  void drawCreator() {
    background(151);

    //--------------------------Instructions for building map------------------
    textAlign(LEFT, CENTER);

    fill(95);
    textSize(21);

    if (trenutno == "Starting point") {
      text("Cars need to start from left pointing right.", 270, 45);
      text("Please place the starting point somewhere in the gray rectangle.", 270, 68);

      rectMode(CORNER);
      fill(130);
      noStroke();    
      rect(10, 90, 250, 620, 10);
    } else if (trenutno == "Walls") {
      text("Press 'space' if you want to 'lift' the pencil", 270, 45);
    } else if (trenutno == "Checkpoints") {
      text("Order of placing is important. Place them along the track (from start to finish).", 270, 45);
      text("It's recommended to put them after sharper corners.", 270, 68);
      text("No need for more than 3-4.", 270, 91);
    } else if (trenutno == "Finish line") {
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

    for (int i=0; i< obstaclesKoor.size(); i+=4) {
      stroke(0);
      strokeWeight(2);
      line(obstaclesKoor.get(i), obstaclesKoor.get(i+1), obstaclesKoor.get(i+2), obstaclesKoor.get(i+3));
    }

    if (startKoor[0] != null) {
      pushMatrix();
      translate(startKoor[0], startKoor[1]);
      rotate(PI/2);
      imageMode(CENTER);
      image(stockAuto, 0, 0);
      popMatrix();
    }

    for (int i = 0; i< checkpointsKoor.size(); i+=2) {
      ellipseMode(RADIUS);
      stroke(0, 200, 0, 100);
      fill(0, 200, 0, 100);
      ellipse(checkpointsKoor.get(i), checkpointsKoor.get(i+1), 85, 85);
    }

    if (finishLineKoor[3] != null) {
      stroke(200, 200, 0);
      strokeWeight(4);
      line(finishLineKoor[0], finishLineKoor[1], finishLineKoor[2], finishLineKoor[3]);
    }
  }



  void mousePresse() {

    // Actual functions for creating map

    switch(flag) {

    case 0:
      startWriter = createWriter("data/maps/3/startingpoint.txt");

      startKoor[0] = (float)mouseX;
      startKoor[1] = (float)mouseY;

      startWriter.println(mouseX + "," + mouseY);
      break;

    case 1:   
      if (x == 0 && y == 0) {
        x = mouseX;
        y = mouseY;
      } else {
        obstaclesKoor.append(x);
        obstaclesKoor.append(y);
        obstaclesKoor.append(mouseX);
        obstaclesKoor.append(mouseY);

        obstacleWriter.println(x + "," + y + "," + mouseX + "," + mouseY);

        x = mouseX;
        y = mouseY;
      }
      break;

    case 2:
      checkMultiplier += 0.25;
      checkpointsKoor.append(mouseX);
      checkpointsKoor.append(mouseY);

      checkpointWriter.println(mouseX + "," + mouseY + ", 170," + checkMultiplier);

      break;
    case 3:
      finishWriter = createWriter("data/maps/3/finishline.txt");

      if (x == 0 && y == 0) {
        x = mouseX;
        y = mouseY;
      } else {
        finishLineKoor[0] = x;
        finishLineKoor[1] = y;
        finishLineKoor[2] = (float)mouseX;
        finishLineKoor[3] = (float)mouseY;   

        finishWriter.println(x + "," + y + "," + mouseX + "," + mouseY);
        finishWriter.println("0,0");

        finishWriter.flush();
      }
      break;
    }
  }

  void keyPresse() {
    if (key == ' ') {
      x = 0;
      y = 0;
    }
    if (key == ENTER) {

      startWriter.flush();
      startWriter.close();

      obstacleWriter.flush();
      obstacleWriter.close();

      checkpointWriter.flush();
      checkpointWriter.close();

      finishWriter.flush();
      finishWriter.close();

      maps[3] = new Map(3);
      m = maps[3];
      changeMap = m;

      // Velike buttone disable-amo jer kreće simulacija
      for (Button b : buttonsForTrackSelection) { 
        b.enabled = false;
      }

      for (int i=0; i<population.cars.length; i++) {
        population.cars[i] = new Car();
      }
      radioButtons[0][m.index].chosen = true;
      population.sw.start();

      programFlow++;
    }

    if (key == 'q') {
      flag = 0; // Slaze se za starting point
      startWriter = createWriter("data/maps/3/startingpoint.txt");
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
      checkpointWriter = createWriter("data/maps/3/checkpoints.txt");
      x = 0;
      y = 0;
      checkMultiplier = 1;
      trenutno = "Checkpoints";
    } else if (key == 'r') {
      flag = 3; // Slaze se finishline
      finishWriter = createWriter("data/maps/3/finishline.txt");
      x = 0;
      y = 0;
      trenutno = "Finish line";
    } else if (key == BACKSPACE) {
      resetMapCreator();
    }
  }

  // Sve ponovno inicijalizirati (resetirati)
  void resetMapCreator() { 
    flag = 0;
    x = 0;
    y = 0;
    obstaclesKoor = new FloatList();
    startKoor = new Float[2];
    checkpointsKoor = new FloatList();
    checkMultiplier = 1;
    finishLineKoor = new Float[4];
    obstacleWriter = createWriter("data/maps/3/obstacles.txt");
    startWriter = createWriter("data/maps/3/startingpoint.txt");
    checkpointWriter = createWriter("data/maps/3/checkpoints.txt");
    finishWriter = createWriter("data/maps/3/finishline.txt");
    trenutno = "Starting point";
  }
}
