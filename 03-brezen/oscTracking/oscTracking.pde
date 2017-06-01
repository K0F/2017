/**
 * based on Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
  happily modded by Kof
 */

import processing.video.*;
import oscP5.*;
import netP5.*;


PImage img;

int PORT = 57120;

int TRESHOLD = 500;

boolean MASK = true;
boolean SHOW = true;
boolean RESULT = false;
boolean REAL = true;
boolean SHOW_POINT = true;

int fps = 30;

float x = 0;
float y = 0;

float sx = 0;
float sy = 0;

int numPixels;
int[] previousFrame;
Capture video;

OscP5 oscP5;
NetAddress myRemoteLocation;

float TRESH = 30.0;

PVector currH, lastH;
float amplitude;
float movementSum;

ArrayList mostDiff;

void setup() {
  size(320, 240, OPENGL);

  img = loadImage("objekt.jpg");

  // time sync 
  frameRate(fps*2);

  currH = new PVector(width/2, height/2);
  lastH = new PVector(width/2, height/2);
  movementSum = amplitude = 0;

  myRemoteLocation = new NetAddress("127.0.0.1", PORT);
  oscP5 = new OscP5(this, 12000);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height, fps);

  // Start capturing the images from the camera
  video.start(); 

  numPixels = video.width * video.height;
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  loadPixels();

  mostDiff = new ArrayList();

  img.loadPixels();
}

void draw() {

  float max = 0;
  movementSum = 0;
  int count = 0;
  background(3);

  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available
    int curPixDiff = 0;

    mostDiff = new ArrayList();

    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      curPixDiff = max(max(diffR, diffG), diffB);
      movementSum += curPixDiff / (width*height*127.0/8.0);

      lastH = new PVector(currH.x, currH.y);
      currH = new PVector(x, y);


      if (curPixDiff >= TRESH) {
        mostDiff.add(new Pix( (i%width), (i/width), curPixDiff));
        count++;
      }



      if (max < curPixDiff) {
        max = curPixDiff;
      }


      if (SHOW)
        pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;

      if(REAL)
        pixels[i] = 0xff000000 | (currR << 16) | ( currG << 8) | currB;
            previousFrame[i] = currColor;

      if (SHOW || REAL)
        updatePixels();


    }

    /*
    // To prevent flicker from frames that are all black (no movement),
    // only update the screen if the image has changed.
    if (movementSum > 0) {
    updatePixels();
    println(movementSum); // Print the total amount of movement to the console
    }
     */

    amplitude = movementSum;

    noStroke();

    //smooth the center, hopefully
    for (int i = 0; i < mostDiff.size(); i++) {
      Pix tmp = (Pix)mostDiff.get(i);

      float len = mostDiff.size()+0.0;
      sx += (x-sx)/len;
      sy += (y-sy)/len;
    }
    // println(count);
    if(count>TRESHOLD){
      analyze();
      sendData();

      if (RESULT)
        displayDiff();

    }
    if(SHOW_POINT)
      displayResult();
  }
}

void analyze() {

  // calcuate medians
  for (int i = 0; i < mostDiff.size(); i++) {
    Pix tmp = (Pix)mostDiff.get(i);
    x += (tmp.x-x)/((float)((256.0-tmp.w)*TRESH));
    y += (tmp.y-y)/((float)((256.0-tmp.w)*TRESH));
  }

}

void sendData() {

  OscMessage myMessage = new OscMessage("/live");
  myMessage.add(1.0-(sx / (width+0.0)));
  myMessage.add(1.0-(sy / (height+0.0)));
  myMessage.add(amplitude);

  oscP5.send(myMessage, myRemoteLocation);
}

void displayResult() {

  fill(255, 120);
  rect(sx, sy, 5, 5);

  fill(255, 128, 0, 120);
  rect(x, y, 5, 5);
}

void displayDiff() {

  for (int i = 0; i < mostDiff.size(); i++) {
    Pix tmp = (Pix)mostDiff.get(i);
    stroke(255, tmp.w);
    point(tmp.x, tmp.y);
  }
}

// helper pix
class Pix {
  int x, y;
  float w;

  Pix(int _x, int _y, float _w) {
    x=_x;
    y=_y;
    w=_w;
  }
}
