
float mul[] = {32.0,16.0,8.0,4.0,2.0,1.0};

float last,now,frame;
float aframe;
float bpm = 90.0;
float abpm = 90.0;
float smooth = 10.0;

void setup(){
  size(320,240,P2D);
  aframe = 1.0;
  last = now = millis();
  frameRate(50);
}


void draw(){
  background(0);

  for(int i = 0 ;i < mul.length;i++){
  fill( (sin(aframe+((millis())/(1000.0)*mul[i])) + 1.0) / 2.0 * 128.0 );
  noStroke();
  rect(width/2.0-2.5,height/3.0-2.5+(i*10),5,5);
  }
}


void keyPressed(){

  if(key==' '){
    last = now;
    now = millis();
    frame = now-last;
    aframe += (frame-aframe)/smooth;

    bpm = 60.0 / (frame/1000.0);
    abpm += (bpm-abpm)/smooth;

    println(aframe+" "+abpm);
  }

}
