

import oscP5.*;
import netP5.*;

MidiThread midi;

OscP5 oscP5;
//name the addresses you'll send and receive @
NetAddress remote;

float tempo = 1.0;

boolean sent;

PVector xyz;

int fps = 50;
int seed = 2017;
ArrayList points;
float SLOPE = 1.0;
int TRACK_LENGTH = 100;

PVector proj;
boolean RENDER = false;

void setup(){
  size(512,512,OPENGL);
  textFont(createFont("Semplice Regular",8,false));
  //noSmooth();
  noiseSeed(seed);
  colorMode(HSB);
  points = new ArrayList();
  oscP5 = new OscP5(this,12000);
  remote = new NetAddress("127.0.0.1",57120);
proj = new PVector(0,0,0);
delay(1);
  OscMessage msg = new OscMessage("/oo_i");
  msg.add("~idiom.play();");
  oscP5.send(msg,remote);


  frameRate(fps);
  midi = new MidiThread(fps*60);
  midi.setPriority(Thread.NORM_PRIORITY+2); 
  midi.start();
}


void draw(){
  float t = (sin(millis()/1000.0*tempo)+1.0) * 2.0 ;
  float shift =  (millis()/100000.0);
  float perlin = pow(noise(t),SLOPE);
  float twoFiveSix = map(perlin,0,1,0,255);

  float x = noise(t,shift,shift);
  float y = noise(shift,t,shift);
  float z = noise(shift,shift,t);
  float scal = min(width,height);
  xyz = new PVector(x*scal,y*scal,z*scal);
  addPoint(xyz.x,xyz.y,xyz.z);

  //pastel aesthetics
  background(210);
  noStroke();

  drawTrack3D();

  fill(0,127);
  ellipse(proj.x,proj.y,proj.z/10.0,proj.z/10.0);

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
    stroke(tmp.x,tmp.y/3.0,tmp.z,map(i,points.size(),0,127,12.5));
    strokeWeight(((tmp.z+ttmp.z)/2.0)/100.0+1.0);
    line(tmp.x,tmp.y,ttmp.x,ttmp.y);
  }
  popStyle();
}

void drawTrack3D(){

  pushStyle();
  pushMatrix();
  translate(0,0,-width/2);
  pushMatrix();
  translate(width/2,height/2,width/2);
  rotateY(frameCount/100.0);
  translate(-width/2,-height/2,-height/2);
  noFill();
  box(100);

  for(int i = 1 ; i < points.size();i++){
    PVector tmp = (PVector)points.get(i);
    PVector ttmp = (PVector)points.get(i-1);
    //stroke(tmp.x,tmp.y/3.0,tmp.z,map(i,points.size(),0,127,12.5));
    stroke(0,map(i,points.size(),0,127,1.5));
    strokeWeight(((tmp.z+ttmp.z)/2.0)/100.0+1.0);
    line(tmp.x,tmp.y,tmp.z,ttmp.x,ttmp.y,ttmp.z);
  }
    proj = new PVector(
    screenX(xyz.x,xyz.y,xyz.z),
    screenY(xyz.x,xyz.y,xyz.z),
    screenZ(xyz.x,xyz.y,xyz.z)
    );
  popMatrix();
  popMatrix();
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
        //    println("sent @ "+timePassed+"ms");

        OscMessage msg = new OscMessage("/oo_i");
        msg.add("~idiom.set(\\x,"+xyz.x+",\\y,"+xyz.y+",\\z,"+xyz.z+" );" );
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

void exit(){
  OscMessage msg = new OscMessage("/oo_i");
  msg.add("~idiom.stop(5);");
  oscP5.send(msg,remote);

  super.exit();
}
