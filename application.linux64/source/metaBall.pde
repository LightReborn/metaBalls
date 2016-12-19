class MetaBall{
  float r;          //size in radius
  float xPos, yPos; //position
  float xVel, yVel; //velocity
  float xAcc, yAcc; //acceleration
  final static float massConstant = 25000;
  final static float G = 0.00000000006673; //used in the calculateForce method to calculate the effects of gravity.
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
  void calculateForce(MetaBall balls[]){
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
  
  void applyForce(float xForce, float yForce){//seperated from update for easy testing, and better coupling.
    xAcc += xForce;
    yAcc += yForce;
  }//end applyForce()
  
  void update(){    
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
  
  void draw(){
    noFill();
    stroke(0,0,255);
    strokeWeight(2);
    ellipse(xPos, yPos, r, r);  
  }//end draw() 
}//end MetaBall class