



import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
FFT fftLog;

AudioInput input;

float bufferL[][];
float bufferR[][];

PGraphics rec;

ArrayList historyL,historyR;
int N = 20;


void setup(){
  size(800,600,OPENGL);
  // sound system
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 800,48000);
  input.mute();
  bufferL = new float[input.bufferSize()][N];
  bufferR = new float[input.bufferSize()][N];


  rec = createGraphics(width,height);
  rec.beginDraw();
  rec.background(0);
  rec.endDraw();

  historyL = new ArrayList();
  historyR = new ArrayList();

  // fft
  // fftLog = new FFT(input.bufferSize(), input.sampleRate());
  // fftLog.logAverages(22, 3);

}


void draw(){

  fill(0,75);
  noStroke();
  rect(0,0,width,height);

  for(int rr = 0 ; rr < N;rr++){

    for(int i = 0 ;i < input.bufferSize();i++){
      if(rr==0){
        bufferL[i][rr] = (input.left.get(i));
        bufferR[i][rr] = (input.right.get(i));
      }else{
        bufferL[i][rr] += (bufferL[i][rr-1]-bufferL[i][rr])/2.0;//(input.left.get(i));
        bufferR[i][rr] += (bufferR[i][rr-1]-bufferR[i][rr])/2.0;//(input.right.get(i));

      }
      float L = pow(map(bufferL[i][rr],-1,1,0,1),3)*1800;
      float R = pow(map(bufferR[input.bufferSize()-i-1][rr],-1,1,0,1),3)*1800;

      float thetaL = PI/(input.bufferSize()+0.0)*i-HALF_PI;
      float thetaR = PI/(input.bufferSize()+0.0)*i+HALF_PI;

      float xL = (cos(thetaL)*L*(rr/(N+1.0)))+width/2;
      float yL = (sin(thetaL)*L*(rr/(N+1.0)))+height/2;

      float xR = (cos(thetaR)*R*(rr/(N+1.0)))+width/2;
      float yR = (sin(thetaR)*R*(rr/(N+1.0)))+height/2;
      stroke(255,75);
      point(xL,yL);
      point(xR,yR);

    }
  }


  /*
     rec.beginDraw();

     for(int i = 0 ;i < input.bufferSize();i++){
     float L = map(bufferL[i],-1,1,0,height);
     float R = map(bufferR[i],-1,1,0,height);
     float theta = PI/1024.0*i;
     float x = i;//(cos(theta)*L)+width/2;
     float y = L;//(sin(theta)*L)+height/2;
     stroke(255,0,0);
     y = R;//(sin(theta)*L)+height/2;
     stroke(0,255,0);
     point(x,y);
     rec.stroke(255,(bufferL[i]+1)*18.0+(bufferR[i]+1.0)*18.0);
     rec.point(x,y+(frameCount%height));

     }
     rec.endDraw();
   */
}
