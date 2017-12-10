

void setup(){
  size(1600,900,P2D);

}

void draw(){

  background(0);
  noStroke();
  fill(255);

float r = 200.0;
  float x = (((sin(millis()/1000.0)+1.0)/2.0) * (width - (2*r))) + r;
  float y = height/2;
  ellipseMode(CENTER);
  ellipse(x,y,r,r);

}
