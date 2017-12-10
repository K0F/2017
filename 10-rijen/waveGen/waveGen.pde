



void setup(){
  size(1920,1080);

}


void draw(){

  background(0);
  stroke(255);

  for(int ii = 1; ii < 5;ii++){
    float sc = pow(noise(frameCount/100.0,ii*10.0,1),4.0) *2000.0;
    float sc2 = noise(frameCount/1000.1,ii*100.0,1)*100.0;
    float sc3 = noise(frameCount/330.0,ii*1000.0,1)*20.0;
    for(int i = 0 ; i < height; i++){
      float f = sin(i*10.0/sc);
      float w = noise( i / (sc2) + (frameCount/(sc3)) ) * f * 200.0;
      line((ii/5.0*width)-w,i,w+(ii/5.0*width),i);

    }}

  saveFrame("/tmp/render/fr#####.tga");


}

