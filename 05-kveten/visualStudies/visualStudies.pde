

ArrayList pix;

void setup(){

  size(320,320,OPENGL);

  pix = new ArrayList();

  for(int y = 0 ; y < height ; y++){
    for(int x = 0 ; x < width ; x++){
      pix.add(new Pix(x,y));
    }
  }


}


void draw(){
  background(0);

  for(int i = 0 ; i < pix.size(); i++){
    Pix tmp = (Pix)pix.get(i);
    tmp.draw();
  }
}

class Pix{

  int x,y;
  PVector origin;

  Pix(int _x, int _y){
    x = _x;
    y = _y;
  }

  void draw(){
    origin = directionTo( new PVector(x,y,0), new PVector(width/2,height/2,sin(millis()/250.0)*255.0 ) );
    stroke(origin.x * 255,origin.y * 255,origin.z * 255);
    point(x,y);
  }
}


PVector directionTo( PVector _a, PVector _b ){
  PVector result  = new PVector(_b.x - _a.x, _b.y - _a.y, _b.z - _a.z );
  result = result.normalize();
  return result;
}
