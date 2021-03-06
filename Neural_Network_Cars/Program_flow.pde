

// File za razne funkcije koje su samo za vizualne efekte.
// Funkcije koje nisu nuzno potrebne za funkcionalnost same simulacije.


void showTitle(){
    textAlign(CENTER, TOP);

    fill(0, 20, 150);             
    textSize(50);         
    text("Neural Network Cars", width/2+2, 2);   
    textSize(28);                                 
    text("Choose starting track", width/2+2, 59); 

    fill(c);
    textSize(50);
    text("Neural Network Cars", width/2, 0);
    textSize(28);
    text("Choose starting track", width/2, 58);
}

void showButtonsForTrackSelection(){

    fill(120);
    stroke(100);
    strokeWeight(10);
    buttonsForTrackSelection[0] = new Button(133, 130, 446, 260, "", 0);
    buttonsForTrackSelection[1] = new Button(701, 130, 446, 260, "", 1);
    buttonsForTrackSelection[2] = new Button(133, 425, 446, 260, "", 2);
    buttonsForTrackSelection[3] = new Button(701, 425, 446, 260, "", 3);

    imageMode(CORNER);

    rect(133, 130, 446, 260);          
    image(tracksImages[0], 143, 140);
    rect(701, 130, 446, 260);
    image(tracksImages[1], 711, 140);

    rect(133, 425, 446, 260);
    image(tracksImages[2], 143, 435);
    rect(701, 425, 446, 260);
    image(tracksImages[3], 711, 435);
   
    showDifficulty(133, 130, "Easy");
    showDifficulty(701, 130, "Normal");
    showDifficulty(133, 420, "Hard");
    showDifficulty(701, 425, "Make your own");
}

 // PNG slike za stanja senzora.
void showSensorStates(){
    imageMode(CORNER);
    for (int i=0; i< sensorStatesImages.length; i++) { 
      int xoff = i*60;
      if(i == sensorState)
        image(sensorStatesImages[i], xoff, height-45, 60, 45);
      else{
        tint(255, 75);
        image(sensorStatesImages[i], xoff, height-45, 60, 45);
        tint(255,255);
      }
    }
    textAlign(LEFT, CENTER);
    textSize(18);
    fill(60);
    text("Scroll to change sensor types.", 22, height - 62);
  }
