import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


ArrayList objects;

float val = 0;

void setup(){
  size(800,600,P2D);
  frameRate(60);
  oscP5 = new OscP5(this,10001);

  objects = new ArrayList();

  rectMode(CENTER);
}

void draw(){
  background(0);
  noStroke();
  
  for(int i = 0 ; i < objects.size(); i++){
    Thing tmp = (Thing)objects.get(i);
    tmp.draw();
  }
  
}

class Thing{
  PVector pos;
  float speed;
  float freq;
  float life = 255;

  Thing(float _x,float _y,float _freq,float _speed){
    pos = new PVector(_x,_y);
    speed = _speed;
    freq = _freq;
  }

  void draw(){
    pushMatrix();
    translate(pos.x,pos.y);
    fill(255,life);
    rect(0,0,10,10);
    popMatrix();

    life*=0.99;

  }



}


void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/bang")==true) {
    val = theOscMessage.get(0).floatValue();
    objects.add(new Thing((millis()%10000)/10000.0*width,map(val,0,500,height,0),val,10.0));
  }  
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}

