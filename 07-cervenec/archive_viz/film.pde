//// FILM //////////////////////////////////////////////////////////////

class Film{

  PVector pos;
  String nazev_katalog;
  String film_id;
  String rok_vyroby;
  String slogan;
  String obsah;
  String delka;
  float w;

  Film(int id,
      String _film_id,
      String _nazev_katalog,
      String _rok_vyroby,
      String _slogan,
      String _obsah,
      String _delka
      ){
    film_id = _film_id;
    nazev_katalog = _nazev_katalog;
    rok_vyroby = _rok_vyroby;
    slogan = _slogan;
    obsah = _obsah;
    delka = _delka;

    pos = new PVector(10,Y);
    Y+=10;

  }


  Film(int id,
      String _film_id,
      String _nazev_katalog,
      String _rok_vyroby,
      String _delka
      ){
    film_id = _film_id;
    nazev_katalog = _nazev_katalog;
    rok_vyroby = _rok_vyroby;
    delka = _delka;

    pos = new PVector(X,Y);
    w = textWidth(nazev_katalog);




  }


  void draw(){

    X+=w+8;
    if(X>width){
      Y+=11;
      X=0;
    }

    pos = new PVector(X,Y);

    boolean over = over();
    color bg = over?color(55,55,55):color(100,100,100);
    color fg = over?color(255,127,12):color(250,250,250);

    pushMatrix();
    translate(pos.x,pos.y);
    fill(bg);
    stroke(fg);
    rect(-2,1,w+4,-10);
    fill(fg);
    text(nazev_katalog,0,0);
    popMatrix();

    if(over){
      fill(bg);
      stroke(fg);
      rect(mouseX-5,mouseY-10,100,40);
      fill(fg);
      text("rok: "+rok_vyroby,mouseX,mouseY);
      text("AIS: "+film_id,mouseX,mouseY+10);
      text("delka: "+delka+"m",mouseX,mouseY+20);
    }
  }

  boolean over(){
    if(mouseX>pos.x-5&&mouseX<pos.x+w+5&&mouseY<pos.y&&mouseY>pos.y-10){
      return true;
    }else{
      return false;
    }

  }
}
