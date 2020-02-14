

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
    float timeSlower =  1; // Needed only for slow PCs.  map(frameRate, 0, 60, 0, 1); // if framerate drops then time moves slower also
    return int(((getElapsedTime()*timeSlower) / 1000) % 60);
  }
}
