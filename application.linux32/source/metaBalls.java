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
public void drawQuadOne(){//x: 0-mid y: 0-mid
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

public void drawQuadTwo(){//x: mid-max y:0-mid
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

public void drawQuadThree(){//x:0-mid y:mid-max
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

public void drawQuadFour(){//x:mid-max y:mid-max
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

public void setup(){
   //size(800,600);
   
   
   widthMid = width /2;
   heightMid = height / 2;
   
   //instantiate the balls
   for (int i = 0; i < metaBallArray.length; i++){
       metaBallArray[i] = new MetaBall(random(25, width-25), random(25, height-25)); //give a random position on the screen within the constraints of the screen.
   }
}//end setup()

public void draw(){
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

public void gravity(){
    for (int i = 0; i < metaBallArray.length; i++) {
      metaBallArray[i].calculateForce(metaBallArray);
    }
}//end gravity()
class MetaBall{
  float r;          //size in radius
  float xPos, yPos; //position
  float xVel, yVel; //velocity
  float xAcc, yAcc; //acceleration
  final static float massConstant = 25000;
  final static float G = 0.00000000006673f; //used in the calculateForce method to calculate the effects of gravity.
//------------------------------------------------------------------------------------------------------------------
  MetaBall(float x, float y, float r){
    xPos = x;
    yPos = y;
    this.r = r;
    
    xVel = random(1,5)*3;
    yVel = random(1,5)*3;
  }
  
  MetaBall (float x, float y){
    xPos = x;
    yPos = y;
    r = random (20,100);
      
    xVel = random(1,5)*3;
    yVel = random(1,5)*3;
  }
//-------------------------------------------------------------------------------------------------------------
  public void calculateForce(MetaBall balls[]){
    //determine the amount of force exterted on this object by other objects.
    for (int i = 0; i < balls.length; i++){
      // F = (G * m1 * m2) / d ^ 2
      
      //universal constant for gravity.
      float m1 = this.r * massConstant;
      float m2 = balls[i].r * massConstant;
      
      //get distance
      float rx = balls[i].xPos - this.xPos;
      float ry = balls[i].yPos - this.yPos;
      float d2 = rx*rx + ry*ry;
      float d = sqrt(d2);
      
      if (d > r && d > balls[i].r){
        // normalize difference vector
        float ux = rx / r;
        float uy = ry / r;

        // acceleration of gravity
        float a = G * m1 * m2 / d2;

        float Fx = a * ux / 1000;
        float Fy = a * uy / 1000;
        
        this.applyForce(Fx,Fy);
      }
    }
  }//end calculateForce()
  
  public void applyForce(float xForce, float yForce){//seperated from update for easy testing, and better coupling.
    xAcc += xForce;
    yAcc += yForce;
  }//end applyForce()
  
  public void update(){    
    //update the velocity to account for acceleration.
    xVel += xAcc;
    yVel += yAcc;
    
    xPos += xVel;
    yPos += yVel;
    
    //ensure the objects stay on screen.
    if (this.xPos - r/2 <= 0){
      //System.out.println("Bump left.");
      if (this.xVel < 0) { 
        xVel *= -1; 
      }
    } else if (this.xPos + r/2 >= width) {
      //System.out.println("Bump right.");
      if (this.xVel > 0) { 
        xVel *= -1; 
      }
    }//end elseif
    
    if (this.yPos - r/2 <= 0){
      //System.out.println("Bump top.");
      if (this.yVel < 0) { 
        yVel *= -1; 
      }
    } else if (this.yPos + r/2 >= height) {
      //System.out.println("Bump bottom.");
      if (this.yVel > 0) { 
        yVel *= -1; 
      }
    }//end elseif
    
    //set acceleration to 0.
    this.xAcc = 0;
    this.yAcc = 0;
    
    //maybe have the balls resize themselves time to time?    
  }//end update()
  
  public void draw(){
    noFill();
    stroke(0,0,255);
    strokeWeight(2);
    ellipse(xPos, yPos, r, r);  
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
