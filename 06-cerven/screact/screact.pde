import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int val = 0;

void setup(){
  size(800,600,P2D);
  frameRate(60);
  oscP5 = new OscP5(this,10001);
  rectMode(CENTER);
}

void draw(){
  background(0);
  noStroke();
  fill(val);
  rect(width/2,height/2,100,100);
  if(val>0)
    val *= 0.8;
}


void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/bang")==true) {
    val = 255;    
  }  
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}

