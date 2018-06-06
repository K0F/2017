
void setup() {
  size(720, 576, OPENGL);
  frameRate(60);
  background(0);
}

void draw() {
  background(0);
  
  translate(width/2,height/2);
  rotateY(frameCount/100.0);
  float R = 100.0;
  
  stroke(255);
  for(float ii = -PI; ii < PI; ii+=0.1){
  
  for(float i = 0; i < TWO_PI; i+=0.1){
    float x = cos(i) * sin(ii / sin(frameCount/1000.0+i)) * R;
    float y = sin(i) * sin(ii / sin(frameCount/1001.0+i)) * R;
    float z = ii * R;
    point(x,y,z);
  }
 }
}