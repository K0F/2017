import supercollider.*;


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Circle test;
Buffer buffer;
Synth synth;

float samples[];

void setup(){
  size(256,256,P2D);
  ellipseMode(CENTER); 
  samples = new float[width];
  buffer = new Buffer(width, 1);
  buffer.alloc(this, "allocated");

  test = new Circle(width/2,height/2,100);

}

void allocated (Buffer buffer)
{
  buffer.setn(0, width, samples);

  synth = new Synth("playbuf_1");
  synth.set("loop", 1);
  synth.set("bufnum", buffer.index);
  println(buffer.index);
  synth.create(); 
}



void draw(){
     loadPixels(); 
     for(int y = 0 ; y < height ; y++){
     for(int x = 0 ; x < width ; x++){
     pixels[y*width+x] = color(noise(x/(mouseX+10.0),y/(mouseY+10.0),frameCount/100.0)*255.0);
     }
     }
     updatePixels();
  fill(0,5);
  noStroke();
  rect(0,0,width,height);
  float time = millis()/250.0;
  float x1 = (cos(time/10.0)*width/(10.0))+width/2;
  float y1 = (sin(time/10.0)*width/(10.0))+height/2;
  test.move(x1,y1,100);

  test.draw();

  for(int i = 0 ; i < samples.length;i++){
    float y = map(samples[i],-1,1,0,height);
    point(i,y);
  }

  for(int i = 0 ; i < samples.length;i++){
    samples[i] = (Float)test.vals.get(i%(test.vals.size()-1));
  }
  buffer.setn(0, width, samples);

}

void exit()
{
  buffer.free();
  synth.free();
  super.exit();
}

class Circle{

  PVector a;
  float r;
  ArrayList vals;

  Circle(float _x1,float _y1,float _r){
    a = new PVector(_x1,_y1);
    r = _r;
  }

  void collect(){
    loadPixels();
    vals = new ArrayList();
    float d = TWO_PI * r;
    for(float f = 0; f < TWO_PI;f+=(TWO_PI/(samples.length+0.0))){
      int tx = (int)((cos(f)*r/2.0)+a.x)%width;
      int ty = (int)((sin(f)*r/2.0)+a.y)%height;
      vals.add( (float)(brightness(pixels[ty*width+tx])-0.5*2.0)/256.0);
    }
  }

  void send(){
    float [] valsArr = new float[vals.size()];
    for(int i = 0 ; i < valsArr.length;i++){
      valsArr[i] = (Float)vals.get(i)/255.0;

    }

    OscMessage myMessage = new OscMessage("/array");
    myMessage.add(valsArr);
    oscP5.send(myMessage, myRemoteLocation);
  }

  void move(float _x1,float _y1,float _r){
    a.x = _x1;
    a.y = _y1;
    r= _r;
  }

  void draw(){
    collect();
    stroke(255,120);
    ellipse(a.x,a.y,r,r);

    noFill();
    beginShape();
    for(int i = 0 ; i < vals.size();i++){
      float val = (Float)vals.get(i);
      float y = map(val,-1,1,0,height);
      vertex(i,y);
    }
    endShape();
  }
}
