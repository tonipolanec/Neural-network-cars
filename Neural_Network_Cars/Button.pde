
class Button {

  boolean enabled;

  int id;

  float x, y, w, h;
  String text = "";

  Button(float _x, float _y, float _w, float _h, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    id = _id;
    enabled = true;
  }

  Button(float _x, float _y, float _w, float _h, String _text, int _id) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
    id = _id;
    enabled = true;
  }


  void clicked() {

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      if (enabled)
        action();
    }
  }

  void show() {

    rectMode(CORNER);
    fill(131);
    stroke(101);
    strokeWeight(3);
    rect(x, y, w, h);

    fill(0);
    textSize(22);
    textAlign(CENTER, CENTER);
    text(text, x+(w/2), y+(h/2)-2);

    textAlign(LEFT, BOTTOM);
  }

  void action() {

    switch(id) { // Ucini bilo sto ovisno o id-u buttona,
      // svaki switch case je kao onClicked funkcija.
    case 0: 
      m = maps[0];
      changeMap = m;
      break;
    case 1: 
      m = maps[1];
      changeMap = m;
      break;
    case 2: 
      m = maps[2];
      changeMap = m;
      break;
    case 3: 
      programFlow = 1; // Program ulazi u stanje kreiranja mape.
      break;
    default:
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

  void clicked() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      //boolean currentState = chosen;

      for (RadioButton b : radioButtons[radioId]) {
        b.chosen = false;
      }
      //chosen = !currentState; // Moguce "ugasiti" button
      chosen = true;
    }
  }

  void show() {

    if (chosen) {  // Ako je odabran onda je rub zuti
      rectMode(CORNER);
      fill(145);
      stroke(255, 220, 0);
      strokeWeight(3);
      rect(x, y, w, h);

      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);
    } else {
      rectMode(CORNER);
      fill(131);
      stroke(101);
      strokeWeight(3);
      rect(x, y, w, h);

      fill(0);
      textSize(22);
      textAlign(CENTER, CENTER);
      text(text, x+(w/2), y+(h/2)-2);
    }
    textAlign(LEFT, BOTTOM);
  }

  void setActive() {
    for (RadioButton b : radioButtons[radioId]) {
      b.chosen = false;
    }
    chosen = true;
  }

  void action() {
    if (radioButtons[radioId][id].chosen) {
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
        if(maps[3] != null)
          changeMap = maps[3];
        else
          programFlow = 1;
        break;
      default:
        break;
      }
    }
  }
  void reset() {
    for (RadioButton b : radioButtons[radioId]) {
      b.chosen = false;
    }
  }
}
