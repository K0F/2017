

String filename = "prepisy.csv";
String raw[];

ArrayList filmy;

float Y = 10;


void keyPressed(){
  save("filmy_shot.png");
}

void setup(){

  size(1600,800,OPENGL);
  raw = loadStrings(filename);
  filmy = new ArrayList();

  textFont(createFont("Semplice Regular",8));


  for(int i = 0 ; i < raw.length;i++){
    try{

      String line[] = splitTokens(raw[i],",\"");
      filmy.add(new Film(
            line[0],line[1],line[9]
            ));
    }catch(Exception e){
      println("chyba pri cteni "+i);
    }
  }

  sort();
}


void sort(){


  Collections.sort(filmy, new Comparator(){

      int compare(Object o1, Object o2) {
      float p1 = ((Film)o1).getSec();
      float p2 = ((Film)o2).getSec();

      return p1 == p2 ? 0 : (p1 > p2 ? 1 : -1);

      }
      }
      );

}

void draw(){

  background(0);
  for(int i = 0 ; i < filmy.size();i++){
    Film tmp = (Film)filmy.get(i);
    tmp.draw();
  }
}



class Film{
  String nazev;
  String ais;
  String rok;
  String zanr;
  String source;
  String zvukSource;
  String datum;
  String misto;
  String technologie;
  float delka;
  PVector pos,lenpos;

  Film(String _nazev, String _ais, String _delka){
    nazev = _nazev+"";
    ais = _ais+"";
    delka = parseFloat(_delka);
    pos = new PVector(10,Y);
    lenpos = new PVector(10,Y);
    Y+=10;
  }

  float getSec(){
    return delka;
  }

  void draw(){
    noStroke();
    fill(255,120);
    lenpos.x = map(delka,0,10000,0,-500);
    rect(width-10,pos.y, lenpos.x ,5);
    textAlign( LEFT );
    text( nazev + " " + ais + " " ,pos.x,pos.y);
    textAlign( RIGHT );
    text( delka, width+lenpos.x-10, pos.y+5 );
    pos.y += ( map(delka, 0, 10000, 10,height-10)-pos.y)/100.0;
  }
}
