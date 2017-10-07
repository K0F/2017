
PShader basic;
float angle;
PGraphics feedback;

float siz = 150.0;

boolean render = false;

void setup(){

  size(1280,720,OPENGL);
  noStroke();
  smooth();

  frameRate(25);

  feedback  = createGraphics(width,height);
  feedback.beginDraw();
  feedback.background(0);
  feedback.endDraw();

  basic = loadShader("frag.glsl","vert.glsl");
  background(250);
}

boolean pass;

void draw(){



  try{
    basic = loadShader("frag.glsl","vert.glsl");
    shader(basic);
    basic.set("tt",millis()/1000.0);

    if(pass == false){
      println("shader OK!");
      pass = true;
    }
  }catch(Exception e){
    println("error compiling shader "+e);
    pass = false;
  };

  rect(0,0,width,height);

   if(render)
  saveFrame("/media/tmpfs/frame_#####.tga");
}

void keyPressed(){
  if(keyCode==' ' || key == ' '){
    basic = loadShader("frag.glsl","vert.glsl");
  }
}
