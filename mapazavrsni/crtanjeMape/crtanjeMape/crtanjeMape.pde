
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
  
  for(int i=0; i< lines.size(); i+=4){
    stroke(0);
    strokeWeight(2);
    line(lines.get(i),lines.get(i+1),lines.get(i+2),lines.get(i+3)); 
  }
  
  try{
  float a = map(1,1,1,1,4);
  }catch(Exception e){
  
  }
}



void mousePressed(){
  if(x == 0 && y == 0){
    x = mouseX;
    y = mouseY;
  }else{
    stroke(0);
    strokeWeight(2);
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
