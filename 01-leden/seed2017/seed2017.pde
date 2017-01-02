

import oscP5.*;
import netP5.*;

MidiThread midi;

OscP5 oscP5;
//name the addresses you'll send and receive @
NetAddress remote;

boolean sent;

PVector xyz;

int fps = 25;
int seed = 2017;
ArrayList points;
float SLOPE = 1.0;
int TRACK_LENGTH = 300;

boolean RENDER = true;

void setup(){
  size(256,256,P2D);
  textFont(createFont("Semplice Regular",8,false));
  //noSmooth();
  noiseSeed(seed);
  colorMode(HSB);
  points = new ArrayList();
  oscP5 = new OscP5(this,12000);
  remote = new NetAddress("127.0.0.1",1234);


  frameRate(fps);
  midi = new MidiThread(fps*60);
  midi.setPriority(Thread.NORM_PRIORITY+2); 
  midi.start();

}


void draw(){
  float t = millis()/1000.0;
  float perlin = pow(noise(t),SLOPE);
  float twoFiveSix = map(perlin,0,1,0,255);

  float x = noise(t,0,0);
  float y = noise(0,t,0);
  float z = noise(0,0,t);
  float scal = min(width,height);
  xyz = new PVector(x*scal,y*scal,z*scal);
  addPoint(xyz.x,xyz.y,xyz.z);

  //pastel aesthetics
  background(xyz.x,xyz.y/2.0,xyz.z);
  noStroke();

  drawTrack();

  fill(0,127);
  ellipse(xyz.x,xyz.y,xyz.z/10.0,xyz.z/10.0);

  int ln = 10;
  fill(0);
  text("seed:" + seed,5,height-(ln*5));
  text("time: "+t,5,height-(ln*4));
  text("x: "+xyz.x/256.0,5,height-(ln*3));
  text("y: "+xyz.y/256.0,5,height-(ln*2));
  text("z: "+xyz.z/256.0,5,height-ln);

  if(sent)
    sent = false;

  if(RENDER)
    saveFrame("/tmp/render/#####seed.tga");
}

void drawTrack(){

  pushStyle();
  noFill();
  for(int i = 1 ; i < points.size();i++){
    PVector tmp = (PVector)points.get(i);
    PVector ttmp = (PVector)points.get(i-1);
    stroke(255-tmp.x,255-tmp.y,255-tmp.z,map(i,points.size(),0,127,12.5));
    strokeWeight(((tmp.z+ttmp.z)/2.0)/100.0+1.0);
    line(tmp.x,tmp.y,ttmp.x,ttmp.y);
  }
  popStyle();
}

void addPoint(float _x,float _y,float _z){

  points.add(new PVector(_x,_y,_z));
  if(points.size()>TRACK_LENGTH){
    points.remove(0);
  }
}

// also shutdown the midi thread when the applet is stopped
public void stop() {
  if (midi!=null) midi.isActive=false;
  super.stop();
}

class MidiThread extends Thread {

  long previousTime;
  boolean isActive=true;
  double interval;

  MidiThread(double bpm) {
    // interval currently hard coded to quarter beats
    interval = 1000.0 / (bpm / 60.0); 
    previousTime=System.nanoTime();
  }

  void run() {
    try {
      while(isActive) {
        // calculate time difference since last beat & wait if necessary
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }
        // insert your midi event sending code here
        println("sent @ "+timePassed+"ms");

        OscMessage msg = new OscMessage("/kof/xyz");
        msg.add(xyz.x);
        msg.add(xyz.y);
        msg.add(xyz.z);
        oscP5.send(msg,remote);
        sent = true;

        // calculate real time until next beat
        long delay=(long)(interval-(System.nanoTime()-previousTime)*1.0e-6);

        if(delay<0)delay=0;

        previousTime=System.nanoTime();

        Thread.sleep(delay);
      }
    }
    catch(InterruptedException e) {
      println("force quit...");
    }
  }
} 
