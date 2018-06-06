

PGraphics off;

void setup(){

  size(320,320,P2D);

}


void draw(){

  off = createGraphics((int)(width*1.5),(int)(height*1.5));

  off.beginDraw();
  off.clear();
  off.noStroke();
  off.rectMode(CENTER);
  off.fill(255,60);
  for(int i = 0 ; i < 100;i+=2){
  float R = (sin(millis()/10001.0+i)+1.0) * 100.0;
  off.rect((cos(millis()/(1000.0+i)))*(R+(i*3))+(off.width/2.0),(sin(millis()/(1000.0+i)))*(R+(i*3))+(off.height/2.0),10.0,10.0);
  }
  //off.stroke(255,30);
  //off.line(width/2,i,width,height/2+i);
  off.endDraw();

  //background(0);

  float steps = 5;
  pushMatrix();

  translate(width/2,height/2);

  for(float f = 0.0 ;f < TWO_PI;f+=TWO_PI/steps){
    rotate(TWO_PI/steps);
    image(off,-off.width/2.0,-off.height/2.0);
  }


  popMatrix();

}
