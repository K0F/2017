

////////////////////////////////////////
//  SETUP /////////////////////////////
//////////////////////////////////////

int num = 1000;
float ATTRACTION = 1000.0;
float FRICTION = 0.9977;
float INTERTIA = 0.00335;

int BLENDING = 64;


color bck = color(#FAE3AF);
color fg = color(#22223B);

float IMPULSE = 3.5;

//////////////////////////////////////

ArrayList entities;
PVector cam;

void setup(){
  size(800,800,P2D);

  entities =new ArrayList();

  cam = new PVector(width/2,height/2);

  for(int i = 0 ; i < num;i++){
    entities.add(new Entity());
  }

}

///////////////////////////////////////////////


void grid(float _siz){
  stroke(0,5);
  for(float x = -cam.x+width/2.0 ; x < width-cam.x + (width/2.0) ; x += _siz){
    line(x,0,x,height);
  }

  for(float y = -cam.y+height/2.0 ; y < height-cam.y + (height/2.0) ; y += _siz){
    line(0,y,width,y);
  }
}

///////////////////////////////////////////////

void draw(){
  fill(213,200,166,BLENDING/2.0);
  rectMode(CORNER);
  rect(0,0,width,height);

  grid(20);

  pushMatrix();
  translate(-width/2+cam.x,-height/2+cam.y);
  rectMode(CENTER);
  for(int i = 0 ; i < entities.size();i++){
    Entity tmp = (Entity)entities.get(i);
    tmp.draw();
  }
  popMatrix();
}


///////////////////////////////////////////////


class Entity{
  PVector ppos,pos,acc,vel;

  Entity(){
    ppos = new PVector(width/2,height/2);
    pos = new PVector(width/2,height/2);
    acc = new PVector(random(-IMPULSE,IMPULSE),random(-IMPULSE,IMPULSE));
    vel = new PVector(acc.x,acc.y);
  }

  void draw(){
    move();

    noStroke();

    stroke(34,34,59,BLENDING);
    if(dist(pos.x,pos.y,ppos.x,ppos.y)<100)
      line(pos.x,pos.y,ppos.x,ppos.y);
    noStroke();
  }

  void move(){

    cam.x += (pos.x-cam.x)/(entities.size());
    cam.y += (pos.y-cam.y)/(entities.size());


    ppos=new PVector(pos.x,pos.y);

    pos.add(vel);
    vel.add(acc);

    vel.mult(FRICTION);
    acc.mult(INTERTIA);


    for(int i = 0 ; i < entities.size();i++){
      Entity other = (Entity)entities.get(i);
      if(other!=this){
        float d = dist(other.pos.x,other.pos.y,pos.x,pos.y);
        acc.x += (other.pos.x-pos.x)/(d+1.0)/ATTRACTION;
        acc.y += (other.pos.y-pos.y)/(d+1.0)/ATTRACTION;
      }
    }
    //border();
  }

  void border(){
    if(pos.x>width)
      pos.x = 0;
    if(pos.x<0)
      pos.x = width;
    if(pos.y>height)
      pos.y = 0;
    if(pos.y<0)
      pos.y = height;
  }
}
