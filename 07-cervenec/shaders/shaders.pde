
PShader basic;
float angle;
PGraphics feedback;

float siz = 150.0;

boolean render = true;

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
  translate(-150,0);
  fill(255,30,40,30);
  pushMatrix();
  rotateY(angle*0.1);
  sphere(siz);
  popMatrix();
  translate(150,0);
  fill(40,255,30,30);
  pushMatrix();
  rotateY(angle*0.1);
  sphere(siz);
  popMatrix();
  translate(150,0);
  fill(40,30,255 ,30);
  pushMatrix();
  rotateY(angle*0.1);
  sphere(siz);
  popMatrix();

  angle += 0.001;
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
