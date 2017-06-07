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

boolean isNotOnStaff(int loc, int[] lines) { // loc and lines are both in rows, divided by score.width
  for (int i = 0; i < lines.length; i ++) {
    if (abs(loc - lines[i]) <= 1) {
      return false;
    }
  }
  return true;
}

void markStaff(int loc) { // loc is the bottom right corner of a staff
  int topRight = getTop(loc);
  int topLeft = getLeft(topRight);
  int pointer = topLeft + 50;
  for (int i = topRight; i % score.width > -1; i --) {
    System.out.println(score.pixels[i] == color(0, 0, 0));
  }
  System.out.println(score.pixels[topLeft] == color(0, 0, 0));
  mark(pointer, 3, -1412412);
  int[] topStaff = new int[5]; // in rows
  int place = topLeft;
  for (int i = 0; i < 5; i ++) {
    topStaff[i] = place / score.width;
    place = moveDownOne(place);
  }
  System.out.println(topStaff[0]);
  /*for (int i = 0; i < topStaff.length; i ++) {
    mark(topStaff[i] * score.width + 250, 1, -442232);
  }*/
  int heightDifference = (staffLines.get(2) - topRight) / score.width;
  for (int i = pointer % score.width; i < topRight % score.width; i ++) {
    int topLine = pointer / score.width;
    for (int h = 0; h < heightDifference; h ++) {
      if (isNotOnStaff(h + topLine, topStaff)) {
        //score.pixels[(topLine + h) * score.width + i] = -15456196;
        System.out.println(score.pixels[(topLine + h) * score.width + i]);
        //PROCEED WITH CHECKING FOR NOTES OR RESTS HERE
        if (score.pixels[(topLine + h) * score.width + i] != color(255, 255, 255)) {
          score.pixels[(topLine + h) * score.width + i] = -55123;
        }
      }
    }
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
  markStaff(staffLines.get(0));
  score.save("Data/ugly.png");
}

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  score.updatePixels();
}

//void recognizeStaff(){}

//void recognizeStaffLines(){}