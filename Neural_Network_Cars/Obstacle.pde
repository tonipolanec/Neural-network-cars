/*
class Obstacle {
  float x1, y1, x2, y2;

  Obstacle(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }

  void show() {
    stroke(0, 0, 255);
    strokeWeight(3);
    line(x1, y1, x2, y2);
  }
}


void inicijalizacijaObstaclei() {

  //Nazalost zbog samog nacina funkiconiranja programa
  //postavljanje obstacle-i mora biti rucno

  //Kreiranje zidova(svaki zid(crta) poprima 4 atributa -> x1,y1,x2,y2)
  if(!novaMapa){
    obst[0] = new Obstacle(0, 280, 180, 280);
    obst[1] = new Obstacle(0, 440, 300, 440);
    obst[2] = new Obstacle(180, 280, 350, 200);
    obst[3] = new Obstacle(300, 440, 390, 320);
    obst[4] = new Obstacle(350, 200, 500, 200);
    obst[5] = new Obstacle(390, 320, 600, 320);
    obst[6] = new Obstacle(500, 200, 600, 100);
    obst[7] = new Obstacle(600, 320, 700, 230);
    obst[8] = new Obstacle(600, 100, 900, 100);
    obst[9] = new Obstacle(700, 230, 800, 230);
    obst[10] = new Obstacle(900, 100, 930, 130);
    obst[11] = new Obstacle(800, 230, 800, 330);
    obst[12] = new Obstacle(930, 130, 930, 440);
    obst[13] = new Obstacle(930, 440, 850, 480);
    obst[14] = new Obstacle(800, 330, 640, 450);
    obst[15] = new Obstacle(640, 450, 640, 680);
    obst[16] = new Obstacle(850, 480, 850, 530);
    obst[17] = new Obstacle(640, 680, 1150, 680);
    obst[18] = new Obstacle(850, 530, 1000, 530);
    obst[19] = new Obstacle(1000, 530, 1100, 450);
    obst[20] = new Obstacle(1150, 680, 1200, 600);
    obst[21] = new Obstacle(1200, 600, 1200, 100);
    obst[22] = new Obstacle(1100, 450, 1100, 100);
    obst[23] = new Obstacle(1100, 100, 1050, 40);
    obst[24] = new Obstacle(1200, 100, 1250, 40);
    obst[25] = new Obstacle(1050, 0, 1050, 40);
    obst[26] = new Obstacle(1250, 0, 1250, 40);
    obst[27] = new Obstacle(0, 280, 0, 440); // iza starta
    
  }else{
    obst[0] = new Obstacle(0,180,0,360);
  
    obst[1] = new Obstacle(0,180,182,180);
    obst[2] = new Obstacle(182,0,182,180);
    obst[3] = new Obstacle(182,0,550,0);
    obst[4] = new Obstacle(550,0,550,180);
    obst[5] = new Obstacle(550,180,1100,180);
    obst[6] = new Obstacle(1100,0,1100,180);
    //obst[7] = new Obstacle(1100,0,1280,0);
    
    obst[7] = new Obstacle(368,180,368,360);
    obst[8] = new Obstacle(368,360,917,360);
    obst[9] = new Obstacle(917,360,917,540);
    
    obst[10] = new Obstacle(0,360,182,360);
    obst[11] = new Obstacle(182,360,182,540);
    obst[12] = new Obstacle(182,540,733,540);
    obst[13] = new Obstacle(733,540,733,720);
    obst[14] = new Obstacle(733,720,1100,720);
    obst[15] = new Obstacle(1100,360,1100,720);
    obst[16] = new Obstacle(1100,360,1280,360);
    obst[17] = new Obstacle(1280,0,1280,360);
  }
}


class FinishLine {
  float x1, y1, x2, y2;

  FinishLine(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
  }

  void show() {
    stroke(255, 242, 0);
    strokeWeight(3);
    line(x1, y1, x2, y2);
  }
}

*/
