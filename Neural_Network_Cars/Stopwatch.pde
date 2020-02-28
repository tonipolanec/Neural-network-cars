

class Stopwatch {
  int startTime = 0;
  boolean running = false; 
  
  int minute = 0;
  boolean flag = true;
  
  void start() {
    startTime = millis();
    running = true;
  }

  int getElapsedTime() {
    int elapsed = (millis() - startTime);
    return elapsed;
  }
  
  int second() {
    float timeSlower =  1; // Za sporija računala.  map(frameRate, 0, 60, 0, 1); // Ako padne framerate tada se i vrijeme ospori
    int seconds = int(((getElapsedTime()*timeSlower) / 1000) % 60);
    int time;
    if(seconds == 59 && flag == true){
      time = 59 + minute*60;
      minute++;
      seconds = 0;
      flag = false;
    }else{
      time = seconds + minute*60;  /// TU NEKAJ NE VALA 119 za 59
    }
    if(seconds == 55)
      flag = true;
    return time;
  }
}
