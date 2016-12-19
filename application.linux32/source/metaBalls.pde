MetaBall metaBallArray[] = new MetaBall[2];
final static boolean drawingCircles = false;
static int widthMid, heightMid;
int luminosity = 95;

//===================================================================================================
//Thread declarations for calculating all the pixels
//quad1
Thread q1 = new Thread(new Runnable(){
  @Override
  public void run(){
      drawQuadOne();
  }
});
//quad2
Thread q2 = new Thread(new Runnable(){
  @Override
  public void run(){
      drawQuadTwo();
  }
});
//quad3
Thread q3 = new Thread(new Runnable(){
  @Override
  public void run(){
      drawQuadThree();
  }
});
//quad4
Thread q4 = new Thread(new Runnable(){
  @Override
  public void run(){
      drawQuadFour();
  }
});
//threaded functions definitions
void drawQuadOne(){//x: 0-mid y: 0-mid
  for (int x = 0; x < widthMid; x++) {
    for (int y = 0; y < heightMid; y++) {
      int index = x + y * width;
      float sum = 0;
      for (MetaBall ball : metaBallArray) {
        float d = dist(x, y, ball.xPos, ball.yPos);
        sum += luminosity * metaBallArray[0].r / d;
      
        pixels[index] = color(sum, 100, 100);
      }
    }
  }
}//end drawQuadOne

void drawQuadTwo(){//x: mid-max y:0-mid
  for (int x = widthMid; x < width; x++) {
    for (int y = 0; y < heightMid; y++) {
      int index = x + y * width;
      float sum = 0;
      for (MetaBall ball : metaBallArray) {
        float d = dist(x, y, ball.xPos, ball.yPos);
        sum += luminosity * metaBallArray[0].r / d;
      
        pixels[index] = color(sum, 100, 100);
      }
    }
  }
}//end drawQuadTwo

void drawQuadThree(){//x:0-mid y:mid-max
  for (int x = 0; x < widthMid; x++) {
    for (int y = heightMid; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (MetaBall ball : metaBallArray) {
        float d = dist(x, y, ball.xPos, ball.yPos);
        sum += luminosity * metaBallArray[0].r / d;
      
        pixels[index] = color(sum, 100, 100);
      }
    }
  }
}//end drawQuadThree

void drawQuadFour(){//x:mid-max y:mid-max
  for (int x = widthMid; x < width; x++) {
    for (int y = heightMid; y < height; y++) {
      int index = x + y * width;
      float sum = 0;
      for (MetaBall ball : metaBallArray) {
        float d = dist(x, y, ball.xPos, ball.yPos);
        sum += luminosity * metaBallArray[0].r / d;
      
        pixels[index] = color(sum, 100, 100);
      }
    }
  }
}//end drawWuadFour

//==============================================================End of pixel threading=====================================================================================

void setup(){
   //size(800,600);
   fullScreen();
   
   widthMid = width /2;
   heightMid = height / 2;
   
   //instantiate the balls
   for (int i = 0; i < metaBallArray.length; i++){
       metaBallArray[i] = new MetaBall(random(25, width-25), random(25, height-25)); //give a random position on the screen within the constraints of the screen.
   }
}//end setup()

void draw(){
  background(0);
  
  loadPixels();
  noStroke();
  colorMode(HSB, 100);
  
  //start thread pixel calculations
  q1.run();
  q2.run();
  q3.run();
  q4.run();
  
  //join threads
  try{
    q1.join();
    q2.join();
    q3.join();
    q4.join();
  }
  catch (Exception e) {
    System.out.println("Error: " + e);
  }
  
  //actually put the pixels up on screen, and begin processes again.
  updatePixels();
  
  //hopefully our gravity calculations are complete by now.
  for (int i = 0; i < metaBallArray.length; i++){
    metaBallArray[i].calculateForce(metaBallArray);
    metaBallArray[i].update();
    if (drawingCircles) {//draw the circles maybe?
      metaBallArray[i].draw(); 
    }
  }
}//end draw()

void gravity(){
    for (int i = 0; i < metaBallArray.length; i++) {
      metaBallArray[i].calculateForce(metaBallArray);
    }
}//end gravity()