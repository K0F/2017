
PShader basic;
float angle;
PGraphics feedback;

float siz = 200.0;

boolean render = false;

void setup(){

  size(1920,1080,OPENGL);
  noStroke();
  smooth();

  frameRate(60);

  feedback  = createGraphics(width,height);
  feedback.beginDraw();
  feedback.background(0);
  feedback.endDraw();

  basic = loadShader("frag.glsl","vert.glsl");
  background(0);
}

boolean pass;

void draw(){
  background(0);

  camera(width/2,height/2,300,width/2,height/2,0,0,1,0);

  translate(width/2,height/2);
  rotateY(angle);
  rotateX(angle/1.3333);
  rotateZ(angle/1.5);
  pointLight(cos(millis()/100.0)*width,sin(millis()/100.1)*height,height/2,width/2,height/2,-height/2);

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

  /*
     beginShape(QUADS);
     normal(0, 0, 1);
     fill(50, 50, 200);
     vertex(-100, +100);
     vertex(+100, +100);
     fill(200, 50, 50);
     vertex(+100, -100);
     vertex(-100, -100);
     endShape();
   */
  sphereDetail(128);
  fill(250);
  pushMatrix();
  rotateX(angle*1.1);
  rotateY(angle*1.11);
  rotateZ(angle*1.111);
  sphere(siz);
  popMatrix();

  angle += 0.01;
  /*
     resetMatrix();
     loadPixels();
     feedback = createGraphics(width,height,P2D);
     feedback.loadPixels();
     for(int i = 0; i < pixels.length;i++){
     feedback.pixels[i] = pixels[i];
     }
     image(feedback,2,2,width-4,height-4);
   */

  if(render)
  saveFrame("/media/tmpfs/frame_#####.tga");
}

void keyPressed(){
  if(keyCode==' ' || key == ' '){
    basic = loadShader("frag.glsl","vert.glsl");
  }
}
