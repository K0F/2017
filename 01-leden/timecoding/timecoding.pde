
/*
   timecode calculator
 */

float FRAMERATE = 24.000;

String filenames[] = {
  "cviceni.txt",
  "hasici.txt",
  "kladeni.txt",
  "pomnik.txt",
  "prostejov.txt",
  "slet.txt",
  "vystava.txt"
};

TimeCode test;
ArrayList list;
String[] ins,outs,raw;

void setup(){
  size(320,240);

  for(int i = 0 ; i < filenames.length;i++){
    parse(filenames[i]);
  }
}

void parse(String _filename){

  String NAME = splitTokens(_filename,".")[0];

  println(NAME.toUpperCase());

  list = new ArrayList();
  raw = loadStrings(_filename);

  ins = new String[raw.length];
  outs = new String[raw.length];

  int offset = 2;
  for(int i = 0 ; i < raw.length;i++){
    ins[i] = splitTokens(raw[i]," ")[offset];
    outs[i] = splitTokens(raw[i]," ")[offset + 1];
  }

  TimeCode abs_tc = new TimeCode(0,0,0);

  println("Číslo materiálu,Filmový materiál,Začátek fragmentu MM:SS:FF,Konec fragmentu MM:SS:FF,Délka fragmentu MM:SS:FF,TC začátek MM:SS:FF,TC konec MM:SS:FF,Poznámky");

  for(int i = 0 ; i < raw.length;i++){


    /////////////////////////////////////////////////////
    // udaje
    /////////////
    String cislo = splitTokens(raw[i]," ")[0];
    String mat = splitTokens(raw[i]," ")[1];
    
    print(cislo + "," + mat + ",");

    int iM = parseInt(splitTokens(ins[i],": ")[0]);  
    int iS = parseInt(splitTokens(ins[i],": ")[1]);  
    int iF = parseInt(splitTokens(ins[i],": ")[2]);  

    int oM = parseInt(splitTokens(outs[i],": ")[0]);  
    int oS = parseInt(splitTokens(outs[i],": ")[1]);  
    int oF = parseInt(splitTokens(outs[i],": ")[2]);  

    TimeCode a = new TimeCode(iM,iS,iF);
    TimeCode b = new TimeCode(oM,oS,oF);

    list.add(sub(b,a));
    
    print( nf(iM,2) + ":" + nf(iS,2) + ":" + nf(iF,2) + "," + nf(oM,2) + ":" + nf(oS,2) + ":" + nf(oF,2) );

    TimeCode tc = (TimeCode)list.get(list.size()-1);
    print("," + nf(tc.minute,2) + ":" + nf(tc.second,2) + ":" + nf(tc.frame,2));

    print( "," + nf(abs_tc.minute,2) + ":" + nf(abs_tc.second,2) + ":" + nf(abs_tc.frame,2) );
    abs_tc = add( abs_tc, tc ); 
    println( "," + nf(abs_tc.minute,2) + ":" + nf(abs_tc.second,2) + ":" + nf(abs_tc.frame,2) );
    abs_tc = add(abs_tc, new TimeCode(0,0,1)); 
  }

  for(int i = 0 ; i < list.size();i++){
    TimeCode tc = (TimeCode)list.get(i);
  }
}

void draw(){
  exit();
}

TimeCode sub(TimeCode a, TimeCode b){

  int A_FRAMES = (int)((a.minute * 60.0 * FRAMERATE) + (a.second * FRAMERATE) + a.frame);
  int B_FRAMES = (int)((b.minute * 60.0 * FRAMERATE) + (b.second * FRAMERATE) + b.frame);

  int RESULT = A_FRAMES - B_FRAMES;

  int mi = (int)((RESULT / FRAMERATE) / 60.0);
  int se = (int)(RESULT / FRAMERATE) % 60;
  int fr = RESULT % (int)round(FRAMERATE);

  return new TimeCode(mi,se,fr);
}


TimeCode add(TimeCode a, TimeCode b){
  int A_FRAMES = (int)((a.minute * 60.0 * FRAMERATE) + (a.second * FRAMERATE) + a.frame);
  int B_FRAMES = (int)((b.minute * 60.0 * FRAMERATE) + (b.second * FRAMERATE) + b.frame);

  int RESULT = A_FRAMES + B_FRAMES;

  int mi = (int)((RESULT / FRAMERATE) / 60.0);
  int se = (int)(RESULT / FRAMERATE) % 60;
  int fr = RESULT % (int)round(FRAMERATE);

  return new TimeCode(mi,se,fr);
}


class TimeCode{
  float rate;
  int hour,minute,second,frame;

  TimeCode(int _minute,int _second,int _frame){
    minute = _minute;
    second = _second;
    frame = _frame;
  }
}

