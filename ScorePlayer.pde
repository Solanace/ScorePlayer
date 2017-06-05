import java.util.ArrayList; 
//Note n;// shouldn't this be ArrayList<Note> Notes or something;
PImage score;

public void setup() {
  size(600, 600);
  score = loadImage("twinkle0.gif");
  score.updatePixels();
}

public void draw() {
  image(score, 0, 0);
  delay(1000);
  score.loadPixels();
  for (int i = 0; i < score.width * score.height; i += 4) {
    score.pixels[i] = color(0, 0, 0);
  }
  score.updatePixels();
  delay(1000);
  score = loadImage("twinkle1.gif");

//void recognizeStaff(){}

//void recognizeStaffLines(){}

}