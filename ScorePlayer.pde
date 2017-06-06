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
  loc = getLoc();
}

int getLoc() {
  for (int c = score.width - 1; c >= 0; c --) {  
    for (int r = score.height - 1; r >= 0; r --)   {
      if (score.pixels[r * score.width + c] == color(0, 0, 0)) {
        return r * score.width + c;
      }
    }
  }
  return -1;
}

int getTop(int loc) { // returns the top of the staff line
  while (loc >= 0) {
    if (score.pixels[loc] != color(0, 0, 0)) {
      return loc;
    }
    loc -= score.width;
  }
  return -1;
}

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  for (int i = loc - 100; i < loc; i ++) {
    score.pixels[i] = color(200, 100, 150);
  }
  int h = getTop(loc);
  for (int i = h - 10 * score.width; i < h; i += score.width) {
    score.pixels[i] = color(200, 166, 200);
  }
  score.updatePixels();
  delay(1000);

//void recognizeStaff(){}

//void recognizeStaffLines(){}

}