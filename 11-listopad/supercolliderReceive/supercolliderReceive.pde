
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
float tempo = 1.0;


void setup(){
  size(200,200,P2D);
  frameRate(50);
  oscP5 = new OscP5(this,12000);

}

void draw(){
  background((sin(millis()/500.0*(tempo))+1.0)*128.0);
  fill((2.0-(sin(millis()/500.0*(tempo))+1.0)) * 255);
  noStroke();
  ellipse(width/2,height/2,100,100);
}

void oscEvent(OscMessage theOscMessage) {
  println(theOscMessage.addrPattern());
  println(theOscMessage.typetag());
  if(theOscMessage.addrPattern().equals("/trig") && theOscMessage.checkTypetag("ff")) {
      float val = theOscMessage.get(1).floatValue();
      tempo = val;
      println(val);
  }
}
