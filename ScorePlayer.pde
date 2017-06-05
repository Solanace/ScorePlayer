import java.util.ArrayList; 
//Note n;// shouldn't this be ArrayList<Note> Notes or something;
//Yeah it should be, I was just testing the Note class
PImage score;
int loc = -1; // location of the bottom right corner of the bottom staff

public void setup() {
  size(800, 600);
  //score = loadImage("twinkle0.gif"); //492 by 596 pixels
  score = loadImage("twinkle2.png");
  score.updatePixels();
  score.loadPixels();
  int i = score.width * score.height;
  /*while (i >= 0 && loc == -1) {
    i --;
    if (score.pixels[i] == color(0, 0, 0)) {
      loc = i;
    }
  }*/
  int loc = getLoc();
}

int getLoc() {
  for (int col = score.width - 1; col >= 0; col --) {
    for (int row = score.height - 1; row >= 0; row --) {
      System.out.println(col * row);
      if (score.pixels[row * col] == color(0, 0, 0)) {
        return row * col;
      }
    }
  }
  return -1;
}
      

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  score.pixels[loc] = color(255, 211, 25);
  score.updatePixels();
  delay(1000);

//void recognizeStaff(){}

//void recognizeStaffLines(){}

}