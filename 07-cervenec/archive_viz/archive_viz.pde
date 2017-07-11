XML xml;
int Y = 10;
int X = 10;

ArrayList films;

void setup() {

  size(1920,1080,P2D);

  //xml = loadXML("XML-AF-DO1944_utf8.xml");
  xml = loadXML("XML-ZF-DO1944_utf8.xml");

  films = new ArrayList();

  textFont(createFont("Semplice Regular",8,false));
  XML[] filmy = xml.getChildren("FILM");
  for (int i = 0; i < filmy.length; i++) {
    XML film = filmy[i];

    int check = 0;
    try{

      String nazev_katalog = film.getChildren("NAZEV-KATALOG")[0].getContent();
      check = 1;
      String film_id = film.getChildren("FILMID")[0].getContent();
      check = 2;
      String rok_vyroby = film.getChildren("ROK-VYROBY")[0].getContent();
      check = 3;
      String delka = film.getChildren("METRAZ-ZF")[0].getContent();
      check = 4;
      /*
         String obsah = film.getChildren("OBSAH")[0].getContent();
         check = 5;
         String slogan = film.getChildren("SLOGAN")[0].getContent();
       */

      films.add(new Film(
            i,
            film_id,
            nazev_katalog,
            rok_vyroby,
            delka
            ));


    }catch(Exception e){
      println("Error adding: "+i+" errno:"+check);
    }
  }
}

void draw(){
 X = 10;
 Y = 10;
  background(0);

  for(int i = 0 ; i < films.size();i++){
    Film tmp = (Film)films.get(i);
    tmp.draw();
  }

}



