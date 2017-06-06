import java.util.ArrayList; 
PImage score;
int loc = -1; // location of the bottom right corner of the bottom staff
ArrayList<Integer> staffLines; // each value is the bottom right of a staff line

public void setup() {
  size(800, 600);
  score = loadImage("twinkle2.png");
  staffLines = new ArrayList<Integer>();
  loc = getBot();
  while (loc >= 0) {
    staffLines.add(loc);
    loc = getNextStaff(getTop(loc));
  }
}

int getBot() {
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

int getNextStaff(int loc) {
  loc -= score.width;
  while (loc >= 0) {
    if (score.pixels[loc] != color(255, 255, 255)) {
      return loc;
    }
    loc -= score.width;
  }
  return -1;
}

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  /*loc = getBot();
  for (int i = loc - 100; i < loc; i ++) {
    score.pixels[i] = color(200, 100, 150);
  }
  int h = getTop(loc);
  for (int i = h - 10 * score.width; i < h; i += score.width) {
    score.pixels[i] = color(200, 166, 200);
  }*/
  for (int i : staffLines) {
    for (int j = i - 20 * score.width; j < i; j += score.width) {
      score.pixels[j] = color(200, 100, 60);
    }
  }
}

//void recognizeStaff(){}

//void recognizeStaffLines(){}