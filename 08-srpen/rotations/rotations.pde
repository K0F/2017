

ArrayList nois;
int sel = 0;
float R = 100.0;
float detail = 0.01;

void setup(){
  size(1024,768,OPENGL);
  frameRate(30);
}

void keyPressed(){
save("shot_circles.png");

}

void draw(){


  translate(width/2,height/2,0);
 ortho();


  noFill();
  stroke(255,100);
  background(12,13,25);
  
 /* 
  stroke(255,0,0);
  line(20,0,0,0,0,0);
  stroke(0,255,0);
  line(0,20,0,0,0,0);
  stroke(0,0,255);
  line(0,0,20,0,0,0);
  */

   rotateX(45);
  rotateZ(radians(frameCount/10.0));
  
  for(int q = 0 ;q < 36;q++){
  int c = 0;
  
  rotateZ(radians(q/10000.0));
 
  float x,y,z;
  float tx,ty,tz;
  float px,py,pz;
  nois = new ArrayList();
  x = y = z = tx = ty = tz = px = py = pz = 0;
  R = (sin(frameCount/1000.0+((1+q)*10.0)+1.0)+1.0 ) / 2.0 * 240;
  
  beginShape();
  for(float t = 0 ; t < PI*2; t+=detail){
    if(c==sel)
      stroke(250,100);
    else
      stroke(255,50);

    c++;

    tx = x;
    ty = y;
    tz = z;
    x = cos(t);
    y = sin(t);
    z = 0;//noise(x+1.0,y+1.0);//sin(t) * R;

    float angle = 90+(frameCount/10.0);

    vertex((x)*R,(y)*R,(z)*R);
    float val = noise((x+1.0)*R/200.0,(y+1.0)*R/200.0,(z+1.0)*R/200.0);
    nois.add(val);
  }
  endShape(CLOSE);

beginShape();
  for(int i = 0 ; i < nois.size();i++){
    float zz = (Float)nois.get(i) * R;
    float xx = cos(i/(nois.size()+0.0)*TWO_PI) * R;
    float yy = sin(i/(nois.size()+0.0)*TWO_PI) * R;
    stroke(200,200,190,100);
    vertex(xx,yy,zz);
  }
  endShape(CLOSE);
  sel = (frameCount%c);
}

}
