/*
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

  
  void choosing(){
    
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      boolean currentState = chosen;
      
      for(Button b : radioButtons){
        b.chosen = false;             
      }
      //chosen = !currentState; // Moguce "ugasiti" button
      chosen = true;
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
    textAlign(LEFT,BOTTOM);

  }
  
  void action(){
    if(radioButtons[id].chosen || buttonsForTrackSelection[id].chosen){
      switch(id) {
        case 0: 
          changeMap = maps[0];
          break;
        case 1: 
          changeMap = maps[1];
          break;
        case 2: 
          changeMap = maps[2];
          break;
        case 3: 
          changeMap = maps[3];
          break;
        default:
          break;
      }

    }
}
  
  
}
*/



class Button {

  int id;
  
  float x, y, w, h;
  String text = "";

  Button(float _x, float _y, float _w, float _h, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    id = _id;
  }
  
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
      action();
    }
  }
  
  void show(){
    
    rectMode(CORNER);
    fill(131);
    stroke(101);
    strokeWeight(3);
    rect(x,y,w,h);
    
    fill(0);
    textSize(22);
    textAlign(CENTER, CENTER);
    text(text, x+(w/2), y+(h/2)-2);
    
    textAlign(LEFT,BOTTOM);

  }
  
  void action(){
    
    switch(id){ // Ucini bilo sto ovisno o id-u buttona,
                // svaki switch case je kao onClicked funkcija.
      case 1:
      
        break;
      case 2:
      
        break;
      
    }

  }
}

class RadioButton extends Button {
  
  int radioId;
  boolean chosen = false;

  RadioButton(float _x, float _y, float _w, float _h, int _radioId, int _id) {
    super(_x, _y, _w, _h, _id);
    radioId = _radioId;
  }
  
  RadioButton(float _x, float _y, float _w, float _h, String _text, int _radioId, int _id) {
    super(_x, _y, _w, _h, _text, _id);
    radioId = _radioId;
  }

  void clicked(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      //boolean currentState = chosen;
      
      for(RadioButton b : radioButtons[radioId]){
        b.chosen = false;             
      }
      //chosen = !currentState; // Moguce "ugasiti" button
      chosen = true;
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
    textAlign(LEFT,BOTTOM);

  }
  
  void action(){
    
    if(radioButtons[radioId][id].chosen){
      switch(id) {
        case 0: 
          changeMap = maps[0];
          break;
        case 1: 
          changeMap = maps[1];
          break;
        case 2: 
          changeMap = maps[2];
          break;
        case 3: 
          changeMap = maps[3];
          break;
        default:
          break;
      }

    }

  }




}
  
  
