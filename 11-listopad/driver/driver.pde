
String[] times;

void setup(){
  size(200,200);
  times = loadStrings("times");
  frameRate(25);
}

void draw(){
  
  if(frameCount%1==0){
    bang();
  }

}

void bang(){
  String tmp[] = new String[1];
  tmp[0] = "seek "+times[(int)random(0,times.length)]+" absolute";
  saveStrings("/tmp/ctl",tmp);
}
