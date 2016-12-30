import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class metaBalls extends PApplet {

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
public void drawQuadOne(){//x: 0-mid y: 0-mid
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

public void drawQuadTwo(){//x: mid-max y:0-mid
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

public void drawQuadThree(){//x:0-mid y:mid-max
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

public void drawQuadFour(){//x:mid-max y:mid-max
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

public void spawnAllPixelCalculationThreads(){
  q1.run();
  q2.run();
  q3.run();
  q4.run(); 
}

public void syncAllPixelCalculationThreads(){
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

public void instantiateMetaBalls(){
  for (int i = 0; i < metaBallArray.length; i++){
       metaBallArray[i] = new MetaBall(random(25, width-25), random(25, height-25)); //give a random position on the screen within the constraints of the screen.
   }
}

public void updateAllMetaBalls(){
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

public void setup(){//initializes important variables
   //size(800,600);
   
   
   widthMid = width /2;
   heightMid = height / 2;
   
   instantiateMetaBalls();
}//end setup()

public void draw(){ //handles all update calls 
  background(0);
  
  loadPixels();
  noStroke();
  colorMode(HSB, 100);
  
  spawnAllPixelCalculationThreads();
  syncAllPixelCalculationThreads();
  updatePixels();
  
  updateAllMetaBalls();
}//end draw()
class MetaBall{
  float radius;          //size in radius
  float xPos, yPos; //position
  float xVel, yVel; //velocity
  float xAcc, yAcc; //acceleration
  final static float massConstant = 25000; //used to tweak interactions between object. The larger the number the greater force each object will exert on other objects
  final static float G = 0.00000000006673f; //Universal gravity constant; used in the calculateForce method to calculate the effects of gravity.
  
//-----------------Constructors-----------------------------
  MetaBall(float x, float y, float r){
    xPos = x;
    yPos = y;
    radius = r;
    
    xVel = random(1,5)*3;
    yVel = random(1,5)*3;
  }
  
  MetaBall (float x, float y){
    xPos = x;
    yPos = y;
    radius = random (20,100);
      
    xVel = random(1,5)*3;
    yVel = random(1,5)*3;
  }
//-------------end of constructors--------------------------

  public void calculateForceByGravity(MetaBall balls[]){
    //determine the amount of force exterted on this object by all other objects.
    for (int i = 0; i < balls.length; i++){ //for every object in the array.
      // Formula for calculating force by gravity:
      // F = (G * m1 * m2) / d ^ 2

      float m1 = this.radius * massConstant;
      float m2 = balls[i].radius * massConstant;
      
      //get distance
      float rx = balls[i].xPos - this.xPos;
      float ry = balls[i].yPos - this.yPos;
      float d2 = rx*rx + ry*ry;
      float d = sqrt(d2);
      
      if (d > radius && d > balls[i].radius){
        // normalize difference vector
        float ux = rx / radius;
        float uy = ry / radius;

        // acceleration due to gravity
        float a = G * m1 * m2 / d2;

        float Fx = a * ux / 1000;
        float Fy = a * uy / 1000;
        
        //I would like to seperate this out of this function later.
        this.applyForce(Fx,Fy);
      }
    }
  }//end calculateForceByGravity()
  
  public void applyForce(float xForce, float yForce){
    xAcc += xForce;
    yAcc += yForce;
  }//end applyForce()
  
  public void updateVelocity(){
    //update the velocity to account for acceleration.
    xVel += xAcc;
    yVel += yAcc;
  }//end updateVelocity
  
  public void resetAcceleration(){
    //set acceleration to 0.
    this.xAcc = 0;
    this.yAcc = 0; 
  }//end resetAcceleration()
  
  public void updatePosition(){
    xPos += xVel;
    yPos += yVel;
  }//end updatePosition()
  
  public void ensureObjectIsOnscreen(){
    //ensure the objects stay on screen.
    if (this.xPos - radius/2 <= 0){
      //System.out.println("Bump left.");
      if (this.xVel < 0) { 
        xVel *= -1; 
      }
    } else if (this.xPos + radius/2 >= width) {
      //System.out.println("Bump right.");
      if (this.xVel > 0) { 
        xVel *= -1; 
      }
    }//end elseif
    
    if (this.yPos - radius/2 <= 0){
      //System.out.println("Bump top.");
      if (this.yVel < 0) { 
        yVel *= -1; 
      }
    } else if (this.yPos + radius/2 >= height) {
      //System.out.println("Bump bottom.");
      if (this.yVel > 0) { 
        yVel *= -1; 
      }
    }//end elseif
  }//end ensureObjectIsOnscreen
  
  public void draw(){//handles drawing the circle where the metaBall should be. (For testing purposes.)
    noFill();
    stroke(0,0,255);
    strokeWeight(2);
    ellipse(xPos, yPos, radius, radius);  
  }//end draw() 
}//end MetaBall class
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "metaBalls" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
