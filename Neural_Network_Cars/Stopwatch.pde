

class Stopwatch {
  int startTime = 0;
  boolean running = false;  

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
    return int(((getElapsedTime()*timeSlower) / 1000) % 60);
  }
}
