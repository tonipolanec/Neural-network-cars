
class Map{
  
  Obstacle[] obstacles;
  Checkpoint[] checkpoints;
  FinishLine finishLine;

  Map(int indexOfAMap){
    obstacles = inicijalizacijaObstaclei(indexOfAMap);
    checkpoints = inicijalizacijaCheckpointi(indexOfAMap);
    finishLine = inicijalizacijaFinishLinea(indexOfAMap);
  }


  Obstacle[] inicijalizacijaObstaclei(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/obstacles.txt");
    Obstacle[] obst = new Obstacle[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",4);
   
      obst[i] = new Obstacle(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    }
    return obst;
  }

  Checkpoint[] inicijalizacijaCheckpointi(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/checkpoints.txt");
    Checkpoint[] cp = new Checkpoint[lines.length];
    for (int i = 0 ; i < lines.length; i++) {
      String[] nums = lines[i].split(",",3);
   
      cp[i] = new Checkpoint(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]));
    }
    return cp;
  }

  FinishLine inicijalizacijaFinishLinea(int indexOfAMap){
    String[] lines = loadStrings("maps/" + indexOfAMap + "/finishline.txt");
    FinishLine fl;
    String[] nums = lines[0].split(",",4);
   
    fl = new FinishLine(Float.parseFloat(nums[0]), Float.parseFloat(nums[1]), Float.parseFloat(nums[2]), Float.parseFloat(nums[3]));
    
    return fl;
  }



  void showObstacles(){   
    for(Obstacle o : obstacles){
      o.show();
    }  
  }

  void showCheckpoints(){   
    for(Checkpoint c : checkpoints){
      c.show();
    }  
  }
  
  void showFinishLine(){
    finishLine.show();
  }

}
