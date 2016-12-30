class MetaBall{
  float radius;          //size in radius
  float xPos, yPos; //position
  float xVel, yVel; //velocity
  float xAcc, yAcc; //acceleration
  final static float massConstant = 25000; //used to tweak interactions between object. The larger the number the greater force each object will exert on other objects
  final static float G = 0.00000000006673; //Universal gravity constant; used in the calculateForce method to calculate the effects of gravity.
  
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

  void calculateForceByGravity(MetaBall balls[]){
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
  
  void applyForce(float xForce, float yForce){
    xAcc += xForce;
    yAcc += yForce;
  }//end applyForce()
  
  void updateVelocity(){
    //update the velocity to account for acceleration.
    xVel += xAcc;
    yVel += yAcc;
  }//end updateVelocity
  
  void resetAcceleration(){
    //set acceleration to 0.
    this.xAcc = 0;
    this.yAcc = 0; 
  }//end resetAcceleration()
  
  void updatePosition(){
    xPos += xVel;
    yPos += yVel;
  }//end updatePosition()
  
  void ensureObjectIsOnscreen(){
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
  
  void draw(){//handles drawing the circle where the metaBall should be. (For testing purposes.)
    noFill();
    stroke(0,0,255);
    strokeWeight(2);
    ellipse(xPos, yPos, radius, radius);  
  }//end draw() 
}//end MetaBall class