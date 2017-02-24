
float last,now,frame;
float aframe;
float bpm = 90.0;
float abpm = 90.0;
float smooth = 7.0;

void setup(){
  size(320,240,P2D);
  last = now = millis();
  frameRate(50);
}


void draw(){
  background((sin(abpm/60.0/frameRate+(millis()/1000.0)*10.0) + 1.0) / 2.0 * 128.0);

}


void keyPressed(){

  if(key==' '){
    last = now;
    now = millis();
    frame = now-last;
    bpm = 60.0 / (frame/1000.0);
    abpm += (abpm-bpm)/smooth;
    println(frame+" "+bpm);
  }

}
