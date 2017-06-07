import java.util.ArrayList; 
PImage score;
int loc = -1; // location of the bottom right corner of the bottom staff
ArrayList<Integer> staffLines; // each value is the bottom right of a staff line
int staffLength;

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
  while (loc % score.width > 5) {
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
  int topLeft = topRight - staffLength;
  int pointer = topLeft + 50;
  for (int i = topRight; i % score.width > 2; i --) {
    //System.out.println(score.pixels[i] != color(255, 255, 255));
  }
  mark(pointer, 3, -1412412);
  int[] topStaff = new int[5]; // in rows
  int place = topLeft;
  for (int i = 0; i < 5; i ++) {
    topStaff[i] = place / score.width;
    place = moveDownOne(place);
  }
  //System.out.println(topStaff[0]);
  /*for (int i = 0; i < topStaff.length; i ++) {
    mark(topStaff[i] * score.width + 250, 1, -442232);
  }*/
  int heightDifference = (loc - topRight) / score.width;
  for (int i = pointer % score.width; i < topRight % score.width; i ++) {
    int topLine = pointer / score.width;
    for (int h = 0; h < heightDifference; h ++) {
      if (isNotOnStaff(h + topLine, topStaff)) {
        //score.pixels[(topLine + h) * score.width + i] = -15456196;
        //System.out.println(score.pixels[(topLine + h) * score.width + i]);
        //PROCEED WITH CHECKING FOR NOTES OR RESTS HERE
        if (score.pixels[(topLine + h) * score.width + i] != color(255, 255, 255)) {
          score.pixels[(topLine + h) * score.width + i] = -55123;
        }
      }
    }
  }
}

public void setup() {
  score = loadImage("twinkle2.png");
  fullScreen();
  score.loadPixels();
  staffLines = new ArrayList<Integer>();
  loc = getBot();
  while (loc >= 0) {
    staffLines.add(loc);
    loc = getNextStaff(getTop(loc));
  }
  for (int i : staffLines) {
    mark(i, 3, -1414213);
  }
  System.out.println(score.width);
  staffLength = getTop(staffLines.get(2)) - getLeft(getTop(staffLines.get(2)));
  println(staffLength);
  mark(getTop(staffLines.get(1)), 3, -242434);
  mark(getTop(staffLines.get(1)) - staffLength, 3, -3434234);
  markStaff(staffLines.get(1));
  score.save("data/ugly.png");
}

public void draw() {
  image(score, 0, 0);
  score.loadPixels();
  score.updatePixels();
}

//void recognizeStaff(){}

//void recognizeStaffLines(){}