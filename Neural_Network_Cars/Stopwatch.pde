

class Stopwatch {
  int startTime = 0, stopTime = 0;
  boolean running = false;  

  void start() {
    startTime = millis();
    running = true;
  }
  void stop() {
    stopTime = millis();
    running = false;
  }
  int getElapsedTime() {
    int elapsed;
    if (running) {
      elapsed = (millis() - startTime);
    } else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  int second() {
    float timeSlower = map(frameRate, 0, 60, 0, 1); // if framerate drops then time moves slower also
    return int(((getElapsedTime()*timeSlower) / 1000) % 60);
  }
}
