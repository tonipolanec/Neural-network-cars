
class Button {

  int id;
  
  float x, y, w, h;
  String text;
  
  boolean chosen = false;


  Button(float _x, float _y, float _w, float _h, String _text, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    id = _id;
  }
  
  void clicked(){
    
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      boolean currentState = chosen;
      for(Button b : radioButtons){
        b.chosen = false;
      }
      chosen = !currentState;
    }
  
  }
  
  void show(){
    
    if(chosen){  // Ako je odabran onda je rub zuti
      rectMode(CORNER);
      fill(145);
      stroke(255,220,0);
      strokeWeight(3);
      rect(x,y,w,h);
      
      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);  
    
    }else{
      rectMode(CORNER);
      fill(131);
      stroke(101);
      strokeWeight(3);
      rect(x,y,w,h);
      
      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);
    }
  }
  
  void action(){
    if(radioButtons[id].chosen){
      switch(id) {
        case 0: 
          println("Null");
          break;
        case 1: 
          println("Alpha");
          break;
        case 2: 
          println("Bravo");
          break;
        case 3: 
          println("Gamma");
          break;
        default:
          break;
      }

    }
}
  
  
}
