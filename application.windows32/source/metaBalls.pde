//constants
final static boolean drawingCircles = false;
int luminosity = 95;
int numberOfBalls = 2;

//handled at execution globals
MetaBall metaBallArray[] = new MetaBall[numberOfBalls];
static int widthMid, heightMid;

//############################################################
//-----------------------Pixel Threading----------------------
//############################################################

//Thread object declarations-------------------------------
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

//threaded function definitions.----------------------------
void drawQuadOne(){//x: 0-mid y: 0-mid
  for (int x = 0; x < widthMid; x++) {
    for (int y = 0; y < heightMid; y++) {
      int index = x + y * width;
      float sum = 0;
      for (MetaBall ball : metaBallArray) {
        float d = dist(x, y, ball.xPos, ball.yPos);
        sum += luminosity * metaBallArray[0].radius / d;
      
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
        sum += luminosity * metaBallArray[0].radius / d;
      
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
        sum += luminosity * metaBallArray[0].radius / d;
      
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
        sum += luminosity * metaBallArray[0].radius / d;
      
        pixels[index] = color(sum, 100, 100);
      }
    }
  }
}//end drawQuadFour

void spawnAllPixelCalculationThreads(){
  q1.run();
  q2.run();
  q3.run();
  q4.run(); 
}

void syncAllPixelCalculationThreads(){
  try{
    q1.join();
    q2.join();
    q3.join();
    q4.join();
  }
  catch (Exception e) {
    System.out.println("Error: " + e);
  }
}//end syncAllThreads

//##################################################
//------------End of pixel threading----------------
//##################################################

void instantiateMetaBalls(){
  for (int i = 0; i < metaBallArray.length; i++){
       metaBallArray[i] = new MetaBall(random(25, width-25), random(25, height-25)); //give a random position on the screen within the constraints of the screen.
   }
}

void updateAllMetaBalls(){
  for (int i = 0; i < metaBallArray.length; i++){
    metaBallArray[i].calculateForceByGravity(metaBallArray);
    metaBallArray[i].updateVelocity();
    metaBallArray[i].resetAcceleration();
    metaBallArray[i].updatePosition();
    metaBallArray[i].ensureObjectIsOnscreen();  
    if (drawingCircles) {//draw circles where metaBalls are (For testing only. Controlled by global constants.)
      metaBallArray[i].draw(); 
    }
  }
}

void setup(){//initializes important variables
   //size(800,600);
   fullScreen();
   
   widthMid = width /2;
   heightMid = height / 2;
   
   instantiateMetaBalls();
}//end setup()

void draw(){ //handles all update calls 
  background(0);
  
  loadPixels();
  noStroke();
  colorMode(HSB, 100);
  
  spawnAllPixelCalculationThreads();
  syncAllPixelCalculationThreads();
  updatePixels();
  
  updateAllMetaBalls();
}//end draw()