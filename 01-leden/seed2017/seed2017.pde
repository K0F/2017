

int seed = 2017;
ArrayList points;

int TRACK_LENGTH = 10000;

void setup(){
  size(256,256,P2D);
  textFont(createFont("Semplice Regular",8,false));
  //noSmooth();

  points = new ArrayList();

  frameRate(30);
  noiseSeed(seed);
}


void draw(){
  float t = millis()/1000.0;
  float perlin = pow(noise(t),0.1);
  float twoFiveSix = map(t,0,1,0,255);

  float x = noise(t,0,0);
  float y = noise(0,t,0);
  float z = noise(0,0,t);
  float scal = min(width,height);
  PVector xyz = new PVector(x*scal,y*scal,z*scal);
  addPoint(xyz.x,xyz.y,xyz.z);

  background(xyz.x,xyz.y,xyz.z);
  noStroke();

  drawTrack();

  fill(0,127);
  ellipse(xyz.x,xyz.y,xyz.z/10.0,xyz.z/10.0);




}

void drawTrack(){

  noFill();
  beginShape();
  for(int i = 0 ; i < points.size();i++){
    stroke(0,map(i,points.size(),0,127,12.5));
    PVector tmp = (PVector)points.get(i);
    vertex(tmp.x,tmp.y);
  }
  endShape();
}

void addPoint(float _x,float _y,float _z){

  points.add(new PVector(_x,_y,_z));
  if(points.size()>TRACK_LENGTH){
    points.remove(0);
  }
}
