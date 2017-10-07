
boolean render = true;


ArrayList shapes;

void setup(){
  size(1920,1080);
  frameRate(30);
  shapes = new ArrayList();
}


void draw(){
  background(255);

  stroke(0);

  float fluctuation = (sin(frameCount/30.0*1.5*2.0)+1.0)/2.0;


  for(int i = 0;i < shapes.size();i++){
    Freehand tmp = (Freehand)shapes.get(i);
    tmp.draw();
    tmp.speed = fluctuation + 1 * 29.97;
  }

if(render)
saveFrame("/media/tmpfs/mouchy#####.tga");

}

void mousePressed(){
  shapes.add(new Freehand((int)random(0,5000),mouseX,mouseY));
}


class Freehand{

  PVector pos;
  int seed;
  int dur;
  float speed;
  int fr;
  float dia;
  int seg;

  Freehand(int _seed, float _x,float _y){
    seed = _seed;
    pos = new PVector(_x,_y);
    dur = 900;
    dia = 100;
    speed = 50.0;
    seg = 2;
  }


  void draw(){

    noiseSeed(seed);


    dia = noise(0,0,fr/speed)*1000.0;
    pushMatrix();
    translate(pos.x,pos.y);
    beginShape();
    for(int i = fr ; i < fr+seg;i++){
      float x = (noise(i/speed,0)-0.5)*dia;
      float y = (noise(0,i/speed)-0.5)*dia;
      vertex(x,y);
    }
    endShape();
    popMatrix();
    fr++;
    if(fr>dur-seg)
      fr = 0;
  }
}
