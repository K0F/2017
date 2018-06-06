import supercollider.*;
import oscP5.*;
import netP5.*;

float[] samples;
Buffer buffer;
Synth synth;
int prevX = -1,
    prevY = -1;
    
void setup ()
{
  // 1 pixel = 1 sample
  //  - vary the sketch width to alter fundamental frequency.
  size(512, 256,P2D);
  
  //smooth();
  frameRate(60);
  
  samples = new float[width];
  for (int i = 0; i < width; i++)
  {
    samples[i] = sin(TWO_PI * i / width);
  }
  
  buffer = new Buffer(width, 1);
  buffer.alloc(this, "allocated");
}

void allocated (Buffer buffer)
{
  buffer.setn(0, width, samples);
  
  synth = new Synth("playbuf_1");
  synth.set("loop", 1);
  synth.set("bufnum", buffer.index);
  synth.create(); 
}

void draw ()
{
  background(10);
  stroke(255);

  for (int i = 0; i < samples.length; i++)
  {
    point(i, (height * 0.5) + (0.5 * height * samples[i]));
  }

for(int i = 0 ; i < samples.length;i++){
  }
    buffer.setn(0, width, samples);
}

void exit()
{
  buffer.free();
  synth.free();
  super.exit();
}

