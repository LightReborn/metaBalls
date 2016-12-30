class MetaBall{
  float radius;          //size in radius
  float xPos, yPos; //position
  float xVel, yVel; //velocity
  float xAcc, yAcc; //acceleration
  final static float massConstant = 25000; //used to tweak interactions between object. The larger the number the greater force each object will exert on other objects
  final static float G = 0.00000000006673; //Universal gravity constant; used in the calculateForce method to calculate the effects of gravity.
  
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

  ForceVector calculateForceByGravity(MetaBall balls[]){    
    ForceVector totalForceOfGravity = new ForceVector();
    
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
        ForceVector metaBallGravity = new ForceVector(Fx, Fy);
        totalForceOfGravity.accumulateForce(metaBallGravity);
      }
    }
    return totalForceOfGravity;
  }
  
  void applyForce(float xForce, float yForce){
    xAcc += xForce;
    yAcc += yForce;
  }
  
  void applyForce(ForceVector gravity){
    xAcc += gravity.forceOnX;
    yAcc += gravity.forceOnY;
  }
  
  void updateVelocity(){
    //update the velocity to account for acceleration.
    xVel += xAcc;
    yVel += yAcc;
  }
  
  void resetAcceleration(){
    //set acceleration to 0.
    this.xAcc = 0;
    this.yAcc = 0; 
  }
  
  void updatePosition(){
    xPos += xVel;
    yPos += yVel;
  }
  
  boolean isHittingLeft(){
    return this.xPos - radius/2 <= 0;
  }
  
  boolean isHittingRight() {
    return this.xPos + radius/2 >= width;
  }
  
  boolean isMovingLeft() {
    return this.xVel < 0;
  }
  
  boolean isMovingRight(){
    return this.xVel > 0;
  }
  
  void constrainX(){ //keep the metaBall from going off the left or right of the screen.
    if (isHittingLeft() && isMovingLeft()){
        xVel *= -1;
    } else if (isHittingRight() && isMovingRight()) {
      xVel *= -1;
    }
  }
  
  boolean isHittingTop(){
    return this.yPos - radius/2 <= 0;
  }
  
  boolean isHittingBottom(){
    return this.yPos + radius/2 >= height;
  }
  
  boolean isMovingUp(){
    return this.yVel < 0;
  }
  
  boolean isMovingDown(){
    return this.yVel > 0;
  }
  
  void constrainY(){//keep the metaBall from going off the top or bottom of screen
    if (isHittingTop() && isMovingUp()){
        yVel *= -1;
    } else if (isHittingBottom() && isMovingDown()) {
        yVel *= -1;
    }
  }
  
  void ensureObjectIsOnscreen(){
    //TODO: Refactor and seperate this function for better readability
    //ensure the objects stay on screen.
    constrainX();
    constrainY();
  }//end ensureObjectIsOnscreen
}//end MetaBall class