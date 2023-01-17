# Neural-network-cars

Project for getting highschool diploma.

## Description

In this project I implemented genetic algorithms and simple neural networks to make cars learn how to drive and not crash in walls. Cars learn through iterations. When they get somewhat good at driving on given track they can be transferred to new track unknown to them to show their driving skills.

## Environment

### Track

Track is designed with three main components.
* Walls
* Checkpoints
* Finish line

<p align="center">
  <img width="800"  src="https://user-images.githubusercontent.com/48983791/213017965-6a397ca4-53db-439e-ad6e-ad8bde314ac2.png">
</p>

Program comes with 3 predefined tracks but also includes track creator so you can train them on your own tracks.


### Car

Cars interact with track using 5 sensors. Sensores are angled (-50°, -20°, 0°, 20°, 50°). Proximity with walls is implemented with simple raycasting using line intersections.

<p align="center">
  <img width="380" height="341" src="https://user-images.githubusercontent.com/48983791/213019119-ac86cda4-12cb-4322-b745-e187ab61ed70.png">
</p>

```processing
float see() {  
  float tempUdaljenost = 0;  
  float udaljenost = sensorStrength;  
  float sjecisteX = loc.x, sjecisteY = loc.y;  

  for (Obstacle o : m.obstacles) {  
    float x1 = o.x1;  
    float y1 = o.y1;  
    float x2 = o.x2;  
    float y2 = o.y2;  

// Matematicki izracun za dobivanje tocke do koje pojedini senzor vidi.
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));   
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));   

    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {  
      float tempX = x1 + (uA*(x2-x1));  
      float tempY = y1 + (uA*(y2-y1));        
      tempUdaljenost = dist(x3, y3, tempX, tempY);  

    // Pronalazenje tocke do koje senzor vidi (ne vidi dalje od zida). 
      if (tempUdaljenost < udaljenost) {  
        udaljenost = tempUdaljenost;  
        sjecisteX = tempX;  
        sjecisteY = tempY;    
      }  
    } else if (uA <= 0 && uA >= 1 && uB <= 0 && uB >= 1) {  
      udaljenost = sensorStrength;  
    }  
  }          

  return udaljenost;  
}  
```


## Inteligence

### Neural network

One car has one brain, neural network built by perceptrons. Every perceptron (or neuron in biological sense) has many inputs and output. For every tick perceptron sums up all values at its input, that sum is thrown at activation function (in this case tanh) and output is given to next perceptrons in line.

Neural network is comprised of input layer, 2 hidden layers and output layer.

<p align="center">
  <img width="600"  src="https://user-images.githubusercontent.com/48983791/213021664-632edb6f-9a57-4acb-91c7-d0abb9976dd5.png">
</p>

Inputs are proximities to walls given by sensors, and outputs are controls for car (acceleration/brake, turn left/right).

### Genetic algorithm

To simulate learning I used simple genetic algorithm. After every iterations same steps are taken to ensure learning.
```processing
void populationIsDead() {  
  println("Generacija " + populationNumber + " je gotova.");  

  takeFitnesses();  
  choosingWinnerCars();  
  parentSelection();  
  makingBabies();  
  goingToNextGeneration();  
}  
```

Fitness gives information how well certain car did in given iteration. So if car drove through almost whole track he will have great fitness and if car crashed at first turn he will have low fitness score.

One third of population with lowest fitness are killed of. Remaining two thirds are chosen for parents. Then they are randomly paired up and they produce offspring again filling up whole population pool (2 parents produce 1 offspring). 
Offspring takes on traits for both parents. More precisely from each parent offspring gets half of a brain (neural network). Mutation is added to add some uncertainty in the system and to make learning more effectiive.

This new population is then taken back on track and the cycle continues.


## Acknowledgments

Thanks to my mentor prof. Krešimir Kočiš.
