

int FRAMESKIP = 1;

XML xml;
float LENGTH;

ArrayList allFrames;
String filenames[];
int START=10;

void setup() {

  size(1920, 320,P2D);

  //colorMode(RGB,1);

  filenames = loadStrings("files.txt");
}


void draw() {

  for (int a = START; a < filenames.length; a++) {
    LENGTH=0;
    println("plotting "+filenames[a]);
    xml = loadXML(filenames[a]);
    XML[] children = xml.getChildren();

    XML frames = xml.getChild("frames");
    XML [] fr = frames.getChildren("frame");

    //allFrames = new ArrayList();

    for (int i = 0; i < fr.length; i++) {
      XML [] keys = fr[i].getChildren("tag");
      if (keys[0].getString("key").equals("lavfi.signalstats.YMIN")) {
        float time = fr[i].getFloat("pkt_pts_time");
        LENGTH = max(time, LENGTH);
      }
    }

    background(0);

    for (int i = START; i < fr.length; i+=FRAMESKIP) {
      XML [] keys = fr[i].getChildren("tag");
      if (keys[0].getString("key").equals("lavfi.signalstats.YMIN")) {
        float time = fr[i].getFloat("pkt_pts_time");
        //LENGTH = max(time, LENGTH); 
        float vals[] = new float[keys.length];
        for (int ii = 0; ii < keys.length; ii++) {
          try {
            vals[ii] = keys[ii].getFloat("value");
            Frame tmp = new Frame(i, time, vals);
        tmp.draw();
          }
          catch(Exception e) {
            println("unable to parse value "+ ii +" @ fr "+i);
          }
        }

        

        //allFrames.add(new Frame(i,time,vals));
      }
    }


    /*

     // allFrames.add(new Frame(time,yavg,uavg,vavg));
     }
     
     }
     
     for(int i = 0 ; i < allFrames.size();i++){
     Frame tmp = (Frame)allFrames.get(i);
     tmp.draw();
     }
     */

    save("pngs/"+filenames[a].substring(0, filenames[a].length()-4)+".png");
  }
}


class Frame {
  float time;
  float YMIN, YLOW, YAVG, YHIGH, YMAX, 
    UMIN, ULOW, UAVG, UHIGH, UMAX, 
    VMIN, VLOW, VAVG, VHIGH, VMAX, 
    VDIF, UDIF, YDIF, 
    SATMIN, SATLOW, SATAVG, SATHIGH, SATMAX, 
    HUEMED, HUEAVG, TOUT, 
    VREP, BRNG;


  float [] c1, c2, c3, c4, c5;
  float [] RGB;
  float R, G, B;
  float x;
  float frame;

  Frame(float _time, float _yavg, float _uavg, float _vavg) {
    time = _time;
    YAVG=_yavg;
    UAVG=_uavg;
    VAVG=_vavg;
    RGB = yuvToRGB(YAVG, UAVG, VAVG);
    R = RGB[0];
    G = RGB[1];
    B = RGB[2];
  }

  Frame(int _frame, float _time, float [] vals) {
    time = _time;
    frame = _frame;

    YMIN = vals[0];
    YLOW = vals[1];
    YAVG = vals[2];
    YHIGH = vals[3];
    YMAX = vals[4];

    UMIN = vals[5];
    ULOW = vals[6];
    UAVG = vals[7];
    UHIGH = vals[8];
    UMAX = vals[9];

    VMIN = vals[10];
    VLOW = vals[11];
    VAVG = vals[12];
    VHIGH = vals[13];
    VMAX = vals[14];

    VDIF = vals[15];
    UDIF = vals[16];
    YDIF = vals[17];

    SATMIN = vals[18];
    SATLOW = vals[19];
    SATAVG = vals[20];
    SATHIGH = vals[21];
    SATMAX = vals[22];

    castColors();
  }

  void castColors() {
    try {
      c1 = yuvToRGB(YMIN, UMIN, VMIN);
      c2 = yuvToRGB(YLOW, ULOW, VLOW);
      c3 = yuvToRGB(YAVG, UAVG, VAVG);
      c4 = yuvToRGB(YHIGH, UHIGH, VHIGH);
      c5 = yuvToRGB(YMAX, UMAX, VMAX);
    }
    catch(Exception e) {
      println("error casting colors @ fr "+frame);
    }
  }

  // color conversion
  // http://softpixel.com/~cwright/programming/colorspace/yuv/

  float [] yuvToRGB2(float Y, float U, float V) {
    float r, g, b;
    r = constrain(Y + 1.140 * V, 0, 255);
    g = constrain(Y - 0.395 * U - 0.581 * V, 0, 255);
    b = constrain(Y + 2.023 * U, 0, 255);
    float rgb[] = {r, g, b};
    return rgb;
  } 

  // https://www.fourcc.org/fccyvrgb.php


  float [] yuvToRGB(float Y, float U, float V) {
    float r, g, b;
    r = Y + (1.475) * (U-128);
    g = Y + ((0.3455) * (U-128) - ((0.7169) * (V-128)));
    b = Y + (1.7790) * (V-128);

    r = constrain( r, 0, 255 );
    g = constrain( g, 0, 255 );
    b = constrain( b, 0, 255 );

    float rgb[] = { r, g, b };
    return rgb;
  } 

  void draw2() {
    x = map(time, 0, LENGTH, 0, width);

    stroke(c3[0], c3[1], c3[2], 100);
    line(x, 0, x, height);
  }

  void draw() {
    x = map(time, 0, LENGTH, 0, width);

    float yy = 0;
    float y = 0;

    float alpha = 255;
    try {

      beginShape();
      noFill();

      stroke(c5[0], c5[1], c5[2], alpha);
      yy = y;
      y += 1/10.0;
      vertex(x, yy*height);

      stroke(c4[0], c4[1], c4[2], alpha);
      yy = y;
      y += 1/4.0;
      vertex(x, yy*height);

      stroke(c3[0], c3[1], c3[2], alpha);
      yy = y;
      y += 1/4.0;
      vertex(x, yy*height);

      stroke(c2[0], c2[1], c2[2], alpha);
      yy = y;
      y += 1/4.0;
      vertex(x, yy*height);

      stroke(c1[0], c1[1], c1[2], alpha);
      yy = y;
      y += 1/10.0;
      vertex(x, yy*height);

      endShape();
    }
    catch(Exception e) {
      println("error drawing frame "+frame);
    }
    //    line(x,0,x,height);
  }
}