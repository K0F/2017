


void setup(){
  size(320,180,P2D);
  createFont("Semplice Regular",8);
  frameRate(59.99);
}


void draw(){

  float n = 0.5*((pow(sin(frameCount/(60.0*60.0*2.0)),1.995)*PI)+1.0);
  float v = (sin( (frameCount/60.0*n) * 30.0 )+1.0) * 127.0;
  background( v );
  
  fill(255-v);
  noStroke();
  //rectMode(CENTER);
  rect(width/2,0,width/2,height);

  //text(millis()/1000.0,width/2,height/2);
  saveFrame("/media/tmpfs/fr#####.tga"); 
}
