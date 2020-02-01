




void showStats(PGraphics pg){
  int cornerX = 20;
  int cornerY = 460;
  int h = pg.height;
  int w = pg.width;
  pushMatrix();
    translate(cornerX, cornerY);
  
    pg.beginDraw();
    pg.background(backgroundColorGray);
    pg.stroke(0);
    pg.strokeWeight(2);
    // Crtanje apscise i ordinate.
    pg.line(15, 15, 15, h-15);
    int maxH = -(h-60);
    pg.line(5,h-25,w-15,h-25);
    int maxW = w-90;
    
    pg.textSize(14);
    pg.fill(0);
    pg.text("total fitness", 25, 20);
    pg.text("generations", w-80, h-35);
    
    // Crtanje strelica.
    pg.translate(15, 15);
    pg.line(0,0, 4,5);
    pg.line(0,0, -4, 5);
    pg.translate(w-30 ,h-40);
    pg.line(0,0, -5,-4);
    pg.line(0,0, -5, 4);
    
    pg.translate(-w+30,0);  // Koordinata 0,0 je postavljena u ishodiste grafa.
    
    int intX = maxW / population.populationNumber;
    int intY;
    if(population.totalFitness < 10000)
      intY = maxH;
    else
      intY = maxH / (int)(population.totalFitness / 10000);
    
    pg.stroke(255,0,0);

    for(int i = intX; i<=maxW; i+=intX){
      pg.line(i, -5, i, 5);
    }

    for(int i = intY; i>=maxH; i+=intY){
      pg.line(-5, i, 5, i);
    }
    
    
    
    
    
    pg.endDraw();
  popMatrix();
  
  image(pg,cornerX,cornerY);
}
