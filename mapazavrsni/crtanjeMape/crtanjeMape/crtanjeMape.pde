
float x = 0,y = 0;

FloatList lines = new FloatList();

PrintWriter output;

void setup(){
  size(1280,720);
  background(151);
  
  output = createWriter("obstacli.txt");
}


void draw(){
  background(151);
  drawLines();
  
  
  for(int i=0; i< lines.size(); i+=4){
    stroke(0);
    strokeWeight(2);
    line(lines.get(i),lines.get(i+1),lines.get(i+2),lines.get(i+3)); 
  }
  

}



void mousePressed(){
  
  //ZA CRTANJE STAZE 
  
  if(x == 0 && y == 0){
    x = mouseX;
    y = mouseY;
  }else{
    stroke(0,0,255);
    strokeWeight(3);
    //line(x,y,mouseX,mouseY);
    
    lines.append(x);
    lines.append(y);
    lines.append(mouseX);
    lines.append(mouseY);
    
    output.println(x + "," + y + "," + mouseX + "," + mouseY);
    
    x = mouseX;
    y = mouseY;
  }
  
 
  
  
  
}

void keyPressed(){
  if(key == ' '){
    x = 0;
    y = 0;
  }
  if(key == 'i'){
    output.flush();
    output.close();
    exit();  
  }

}




void drawLines(){
  
  stroke(0,0,255);
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
  
  
