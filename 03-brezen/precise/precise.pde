import netP5.*;
import oscP5.*;

NetAddress sc;
OscP5 osc;


void setup(){
  size(320,180,P2D);
  createFont("Semplice Regular",8);
  frameRate(60);

  osc= new OscP5(this, 12000);
  sc= new NetAddress("127.0.0.1", 57120); 
}


void draw(){


  if(frameCount==1){


    OscMessage msg = new OscMessage("/oo_i"); 
    msg.add("~one.play();");
    osc.send(msg,sc);

    msg = new OscMessage("/oo_i"); 
    msg.add("\"xterm -e 'screc'\".unixCmd;");
    osc.send(msg,sc);



  }

  float n = 0.5*((sin(frameCount/(60.0*60.0*10.0)*TWO_PI-HALF_PI))+1.0);
  float v = (sin( (frameCount/60.0*n) * 30.0 )+1.0) * 127.0;
  background( v );
  if(frameCount%2==0)
    println(n+","+v);

  fill(255-v);
  noStroke();
  //rectMode(CENTER);
  rect(width/2,0,width/2,height);

  send(map(v,0,255,1,-1),map(n,0,1,1.5,12));

  //text(millis()/1000.0,width/2,height/2);
  saveFrame("/media/tmpfs/fr#####.tga"); 
}


void send(float val,float val2){

  OscMessage msg = new OscMessage("/oo_i"); 
  msg.add("~one.set(\\pan,"+val+");");
  osc.send(msg,sc);

  msg = new OscMessage("/oo_i"); 
  msg.add("~one.set(\\pro,"+val2+");");
  osc.send(msg,sc);



}


void stop(){


  OscMessage msg = new OscMessage("/oo_i"); 
  msg.add("~one.stop();");
  osc.send(msg,sc);


  super.stop();

}
