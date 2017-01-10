import oscP5.*;
import netP5.*;

MidiThread midi;

OscP5 oscP5;
//name the addresses you'll send and receive @
NetAddress remote;
int rawLen = 0;
float tempo = 1.0;

boolean sent;

PVector xy;
PVector xy2;

float fps = 29.97;
int seed = 2017;
ArrayList points;
float SLOPE = 1.0;
int TRACK_LENGTH = 100;

boolean RENDER = false;

ArrayList track1;
int frameNo = 0;
float mapMinX = 30000;
float mapMaxX = 0;
float mapMinY = 30000;
float mapMaxY = 0;
int rawLength = 0;

void setup(){
  size(512,512,OPENGL);
  textFont(createFont("Semplice Regular",8,false));
  //noSmooth();
  noiseSeed(seed);
  colorMode(HSB);
  points = new ArrayList();
  oscP5 = new OscP5(this,12000);
  remote = new NetAddress("127.0.0.1",57120);
  xy = new PVector(0,0,0);
  xy2 = new PVector(0,0,0);

  track1 = new ArrayList();

  String [] raw = loadStrings("01.txt");
  rawLength = raw.length;

  for(int i = 0 ; i < raw.length ; i++){
    float xx = (float)parseFloat(splitTokens(raw[i]," ")[0]);
    float yy = (float)parseFloat(splitTokens(raw[i]," ")[1]);
    track1.add(new PVector(xx,yy));
    mapMaxX = max(xx,mapMaxX);
    mapMinX = min(xx,mapMinX);
    mapMaxY = max(yy,mapMaxY);
    mapMinY = min(yy,mapMinY);
  }

  OscMessage msg = new OscMessage("/oo_i");
  msg.add("~idiom.play();");
  oscP5.send(msg,remote);


  frameRate(fps);
  midi = new MidiThread(fps*60);
  midi.setPriority(Thread.NORM_PRIORITY+2); 
}


void draw(){
  if(frameCount==1)
    midi.start();

  xy2 = new PVector(xy.x,xy.y);

  PVector current = ((PVector)track1.get(frameNo)).copy();
  
  frameNo++;
  
  if(frameNo>rawLength)
  frameNo = 0;

  float x = map(current.x,mapMinX,mapMaxX,0,1);
  float y = map(current.y,mapMinY,mapMaxY,0,1);

  xy = new PVector(x,y); 

  float scal = width;

  //pastel aesthetics
  background(5);
  noStroke();

  println(x+" "+y);
  fill(255,127);
  ellipse(x*scal,y*scal,10,10);

  int ln = 10;
  fill(255);

  text("frameNo: "+frameNo,5,height-(ln*4));
  text("x: "+x,5,height-(ln*3));
  text("y: "+y,5,height-(ln*2));

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
    stroke(255-tmp.x,255-tmp.y/3.0,255-tmp.z,map(i,points.size(),0,127,12.5));
    strokeWeight(((tmp.z+ttmp.z)/2.0)/100.0+1.0);
    line(tmp.x,tmp.y,ttmp.x,ttmp.y);
  }
  popStyle();
}
/*
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
stroke(255,map(i,points.size(),0,127,1.5));
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
 */


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
        msg.add("~idiom.set(\\x,"+xy.x+",\\y,"+xy.y+",\\ax,"+constrain(abs(xy.x-xy2.x),0,2)+",\\ay,"+constrain(abs(xy.y-xy2.y),0,2)+" );" );
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

void keyPressed(){
  OscMessage msg = new OscMessage("/oo_i");
  msg.add("~idiom.rebuild();");
  oscP5.send(msg,remote);

delay(2000);

frameNo = 0;

}

void exit(){
  OscMessage msg = new OscMessage("/oo_i");
  msg.add("~idiom.stop(5);");
  oscP5.send(msg,remote);

  super.exit();
}
