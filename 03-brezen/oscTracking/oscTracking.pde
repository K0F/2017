/**
 * Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */


import processing.video.*;


boolean SHOW = false;

int fps = 10;

float x = 0;
float y = 0;

float sx = 0;
float sy = 0;

int numPixels;
int[] previousFrame;
Capture video;




float TRESH = 10;

PVector currH, lastH;


ArrayList mostDiff;



void setup() {
  size(320, 240, P2D);

  frameRate(fps);

  currH = new PVector(width/2, height/2);
  lastH = new PVector(width/2, height/2);


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
}

void draw() {
  
  
  float max = 0;
  background(3);

  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
    video.loadPixels(); // Make its pixels[] array available
    int curPixDiff = 0;
    
    mostDiff = new ArrayList();


    int movementSum = 0; // Amount of movement in the frame
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
      movementSum += curPixDiff;

      lastH = new PVector(currH.x, currH.y);
      currH = new PVector(x, y);


      if (curPixDiff >= TRESH) {

        mostDiff.add(new Pix( (i%width), (i/width), curPixDiff));

        x += ((i%width)-x)/((float)(256.0-curPixDiff)*5.0);
        y += ((i/width)-y)/((float)(256.0-curPixDiff)*5.0);
      }



      if (max < curPixDiff) {
        max = curPixDiff;
        //          println(x+" "+y);
      }

      // Render the difference image to the screen
      //pixels[i] = color(diffR, diffG, diffB);
      // The following line is much faster, but more confusing to read
      // Save the current color into the 'previous' buffer
      
      
if(SHOW)
      pixels[i] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;

      previousFrame[i] = currColor;
    }

    sx += (x-sx)/10.0;
    sy += (y-sy)/10.0;


if(SHOW)
    updatePixels();

    /*
    // To prevent flicker from frames that are all black (no movement),
     // only update the screen if the image has changed.
     if (movementSum > 0) {
     updatePixels();
     println(movementSum); // Print the total amount of movement to the console
     }
     */
  }

  noStroke();

  fill(255, 120);
  rect(sx, sy, 5, 5);

  fill(255, 128, 0, 120);
  rect(x, y, 5, 5);
  
  
  displayDiff();
}


void displayDiff(){
  
   for(int i = 0 ; i < mostDiff.size();i++){
    Pix tmp = (Pix)mostDiff.get(i);
    stroke(255,tmp.w);
    point(tmp.x,tmp.y);
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