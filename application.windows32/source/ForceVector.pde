class ForceVector{
 float forceOnX;
 float forceOnY;
 
 ForceVector(){
  forceOnX = 0;
  forceOnY = 0;
 }
 
 ForceVector (float x, float y){
  forceOnX = x;
  forceOnY = y;
 }
 
 void accumulateForce(ForceVector incomingVector){
   this.forceOnX += incomingVector.forceOnX;
   this.forceOnY += incomingVector.forceOnY;
 }
}