import java.util.ArrayList; 
PImage score;
int loc = -1; // location of the bottom right corner of the bottom staff
ArrayList<Integer> staffLines; // each value is the bottom right of a staff line

int getBot() { // returns the bottom right of the bottommost staff
  for (int c = score.width - 1; c >= 0; c --) {  
    for (int r = score.height - 1; r >= 0; r --)   {
      if (score.pixels[r * score.width + c] == color(0, 0, 0)) {
        return r * score.width + c;
      }
    }
  }
  return -1;
}

int getTop(int loc) { // returns the top of a staff line, assuming you give it a position in between measures
  while (loc >= 0) {
    if (score.pixels[loc] == color(255, 255, 255)) {
      return loc + 2 * score.width;
    }
    loc -= score.width;
  }
  return -1;
}

int moveUpOne(int loc) {
  while (score.pixels[loc] != color(255, 255, 255)) {
    loc -= score.width;
  }
  while (loc >= 0) {
    if (score.pixels[loc] != color(255, 255, 255)) {
      return loc;
    }
    loc -= score.width;
  }
  return -1;
}

int moveDownOne(int loc) {
  while (score.pixels[loc] != color(255, 255, 255)) {
    loc += score.width;
  }
  while (loc < score.width * score.height) {
    if (score.pixels[loc] != color(255, 255, 255)) {
      return loc;
    }
    loc += score.width;
  }
  return -1;
}

int getNextStaff(int loc) { // returns the bottom of the staff above the given location
  loc -= score.width;
  while (loc >= 0) {
    if (score.pixels[loc] == color(0, 0, 0)) {
      return loc + score.width;
    }
    loc -= score.width;
  }
  return -1;
}

int getLeft(int loc) {
  while (loc % score.width >= 0) {
    if (score.pixels[loc] == color(255, 255, 255)) {
      return loc;
    }
    loc --;
  }
  return -1;
}

void mark (int loc, int r, int hue) { // makes a square of side 2r centered at loc
  for (int i = loc - r * score.width; i <= loc + r * score.width; i += score.width) {
    for (int j = i - r; j <= i + r; j ++) {
      score.pixels[j] = hue;
    }
  }
  if (hue != color(20, 40, 60)) {
    mark(loc, 0, color(20, 40, 60));
  }
}

public void settings() {
  score = loadImage("twinkle2.png");
  size(score.width, score.height);
}

public void setup() {
  score.loadPixels();
  staffLines = new ArrayList<Integer>();
  loc = getBot();
  while (loc >= 0) {
    staffLines.add(loc);
    loc = getNextStaff(getTop(loc));
  }
  for (int i : staffLines) {
    mark(i, 2, color(50, 124, 65));
  }  
  int topRight = getTop(staffLines.get(2));
  mark(topRight, 3, color(53, 123, 221));
  int topLeft = getLeft(topRight);
  mark(moveDownOne(topLeft), 4, color(120, 65, 77));
  int pointer = topLeft + 50;
  mark(pointer, 3, -1412412);
  int heightDifference = (staffLines.get(2) - topRight) / score.width;
  for (int i = pointer % score.width; i < score.width; i ++) {
    for (int h = 0; h < heightDifference; h ++) {
      mark((pointer / score.width + h) * score.width + i, 0, -1412412);
    }
    delay(50);
    image(score, 0, 0);
  }
  score.save("ugly.png");
}

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  score.updatePixels();
}

//void recognizeStaff(){}

//void recognizeStaffLines(){}