import javax.sound.midi.*;
import java.util.Collections;
PImage score, tester;
int WHITE = color(255, 255, 255);
int RED = color(255, 0, 0);
int ORANGE = color(255, 165, 0);
int YELLOW = color(255, 255, 0);
int GREEN = color(0, 255, 0);
int BLUE = color(0, 0, 255);
int PURPLE = color(128, 0, 128);
int BLACK = color(0, 0, 0);
Synthesizer synthesizer;
MidiChannel[] midiChannel;
Instrument[] instruments;
ArrayList<Integer> staffLines, temp, staffEnds;
int spaceBetweenStaves;
int spaceBetweenClefs;
int staffHeight;
boolean doubleClef;
ArrayList<Note> notes;
int startBeat = 0, endBeat = 1;
int startCol, endCol;

void setup(){
  size(1200, 1080);
  //frameRate(1);
  score = loadImage("twinkle1.png");//////////////////////////////////////////////////////////////////////////////////////////////
  //score.resize(score.width*3/2,score.height*3/2);
  cleanse();
  highlightBetween();
  blackenStaffLines();
  bluifyNotes();
  blackenStaffLines();
  staffEnds();
  startCol();
  highlightVert(startCol);
  endCol();
  highlightVert(endCol);
  println("startCol: "+startCol);
  for (int i = 0; i < staffEnds.size() - 1; i ++) {
    if (staffEnds.get(i).equals(staffEnds.get(i + 1))) {
      staffEnds.remove(i);
      i --;
    }
  }
  println(staffEnds);
 // println(""+score.width+" "+score.height);
  score.loadPixels();
  int[] smaller = crop(0, score.width / 2, 0, score.height / 2);
  tester = createImage(score.width / 2, score.height / 2, RGB);
  tester.loadPixels();
  tester.pixels = smaller;
  tester.updatePixels();
  notes = readScore();
  // Margaret's synthesizer
  try {
    synthesizer = MidiSystem.getSynthesizer();
    synthesizer.open();
    midiChannel = synthesizer.getChannels();
    instruments = synthesizer.getDefaultSoundbank().getInstruments();
    synthesizer.loadInstrument(instruments[0]);
  }
  catch (MidiUnavailableException e) {
    print(e);
  }
  //background(0);
  image(score, 0, 0);
  image(tester, 1150, 800);
}
///////////////////////////////////////
void startCol(){//column (x) of the where the staves start
  for (int c=score.width/20; c<score.width; c++){
    int x=0;
    for (int r=staffLines.get(0); r<staffLines.get(0)+staffHeight; r++){
      if (score.pixels[r*score.width+c]!=WHITE){
        x++;
      }
    }
    if (x*1.0/staffHeight>0.85){
      startCol=c;
      return;
    }
  }
}
////////////////////////////////////////////////////////
void endCol(){//column (x) of the where the staves start
  for (int c=score.width; c>score.width/2; c--){
    int x=0;
    for (int r=staffLines.get(0); r<staffLines.get(0)+staffHeight; r++){
      if (score.pixels[r*score.width+c]!=WHITE){
        x++;
      }
    }
    if (x*1.0/staffHeight>0.85){
      endCol=c;
      return;
    }
  }
}
////////////////////////////////////////////////////
void staffHeight(){
  int i=0;
  while (!approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenClefs) && !approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenStaves)){
    i++;
  }
  staffHeight=staffLines.get(i-1)-staffLines.get(0);
}
/////////////////////////////////////////////////////////////////////
void staffEnds() {
  staffEnds = new ArrayList<Integer>();
  //staffEnds.add(staffLines.get(0));
  int count = 0;
  int row = 0;
  while (score.pixels[row * score.width] != BLACK) {
    row ++;
  }
  staffEnds.add(row);
  while (row < score.height) {
    while (count < 4) {
      while (score.pixels[row * score.width] != WHITE) {
        row ++;
      }
      while (score.pixels[row * score.width] != BLACK) {
        row ++;
      }
      count ++;
    }
    count = 0;
    while (score.pixels[row * score.width] != WHITE) {
      row ++;
    }
    staffEnds.add(row - 1);
    try {
      while (score.pixels[row * score.width] != BLACK) {
        row ++;
      }
      staffEnds.add(row);
    }
    catch (ArrayIndexOutOfBoundsException e) {
    }
  }
}
void cleanse(){/////////////////////////EXORCISE////////////////////////////////////////////
staffLines=new ArrayList<Integer>();
for (int r = 0; r < score.height; r ++) {
    int count = 0;
    for (int c = 0; c < score.width; c ++) {
      if (score.pixels[r * score.width + c] != WHITE) {
        count ++;
      }
    }
    if ((count*1.0)/score.width >= 0.55) {
      staffLines.add(r);
      for (int c = 0; c < score.width; c ++) {
        score.pixels[r * score.width + c] = BLACK;
      }
    }
  }
  for (int i=0; i<staffLines.size(); i++){
    //println(staffLines.get(i));
  }
  spaceBetweenStaves=maximum(staffLines);
  secondMaximum(staffLines, spaceBetweenStaves);
  if (doubleClef){
    spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
    println("space between clefs: "+spaceBetweenClefs);
  }
  spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
  println("space between: "+spaceBetweenStaves);
  
  staffHeight();
  println("staff height: "+staffHeight);
}
//////////////////////////////////////////////////
int maximum(ArrayList<Integer> x){
  if (x.size()>1){
    int currentMax=x.get(1)-x.get(2);
    for (int i=2; i<x.size(); i++){
      if (x.get(i)-x.get(i-1)>currentMax){
        currentMax=x.get(i)-x.get(i-1);
        }
    }
     return currentMax;  
  }
  return -1;
}
////////////////////////////////////////////////////////
int secondMaximum(ArrayList<Integer> x, int y){
  if (x.size()>1){
    int currentMax=x.get(1)-x.get(2);
    for (int i=2; i<x.size(); i++){
      if (x.get(i)-x.get(i-1)>currentMax && x.get(i)-x.get(i-1)<y*0.66 && x.get(i)-x.get(i-1)>y*0.15){
        currentMax=x.get(i)-x.get(i-1);
        doubleClef=true;
      }
    }
    return currentMax;
  }
  return -1;
}
//////////////////////////////////////////////
void highlightBetween(){
  for (int i=0; i<staffLines.get(staffLines.size()-1)-staffLines.get(0); i++){
    int current=i+staffLines.get(0);
    /*if (staffLines.contains(current) && staffLines.indexOf(current)!=staffLines.size()-1){
      if (approx(staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current)),spaceBetweenClefs) || 
      (doubleClef && approx(staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current)),spaceBetweenStaves))){
        i+=staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current));
        println(true);
        highlightLine(current,GREEN);
        }
      }*/
     if (!staffLines.contains(i+staffLines.get(0))){
      highlightLine(current);
    }
  }
}
/////////////////////////////////////////////////
void blackenStaffLines() {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLUE) {
      try {
        if (score.pixels[i - score.width] != BLUE &&
            score.pixels[i + score.width] != BLUE) {
              score.pixels[i] = BLACK;
            }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLUE) {
      int count = 0;
      int col = i;
      while (score.pixels[col] == BLUE) {
        count ++;
        col ++;
      }
      if (count > 15) {
        for (int j = i; j <= col; j ++) {
          score.pixels[j] = BLACK;
        }
      }
    }
  }
}
/////////////////////////////////////////////////
void bluifyNotes() {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLACK) {
      try {
        if (score.pixels[i - score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = score.pixels.length - 1; i > -1; i --) {
    if (score.pixels[i] != WHITE &&
        score.pixels[i] != BLUE) {
      try {
        if (score.pixels[i + score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < staffLines.get(0) * score.width; i ++) {
    if (score.pixels[i] == BLACK) {
      if (score.pixels[i + 1] == BLUE ||
          score.pixels[i - 1] == BLUE) {
            score.pixels[i] = BLUE;
          }
    }
  }
  for (int i = score.pixels.length - 1; i > -1; i --) {
    if (score.pixels[i] != WHITE &&
        score.pixels[i] != BLUE) {
      try {
        if (score.pixels[i + score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < staffLines.get(0) * score.width; i ++) {
    if (score.pixels[i] == BLACK) {
      if (score.pixels[i + 1] == BLUE ||
          score.pixels[i - 1] == BLUE) {
            score.pixels[i] = BLUE;
          }
    }
  }
}
/////////////////////////////////////////////////
boolean approx(int x, int y){
  if (Math.abs(x-y)*1.0/y<0.04){
    return true;
  }
  return false;
}
////////////////////////////////////
void highlightLine(int x){
  for (int i=0; i<score.width; i++){
    if (score.pixels[x*score.width+i]!=WHITE){
      score.pixels[x*score.width+i]=BLUE;
    }
  }
}

void highlightVert(int y){
  for (int i=0; i<score.height; i++){
    if (score.pixels[i*score.width+y]!=WHITE){
      score.pixels[i*score.width+y]=RED;
    }
  }
}

ArrayList<Note> readScore(){//completes the notes arraylist
  ArrayList<Note> notes = new ArrayList<Note>();
  int[] starts = new int[staffEnds.size() / 2];
  int[] ends = new int[staffEnds.size() / 2];
  for (int i = 0; i < staffEnds.size(); i ++) {
    if (i % 2 == 0) {
      starts[i / 2] = staffEnds.get(i);
    }
    else ends[i / 2] = staffEnds.get(i);
  }
  int count = 0;
  while (count < starts.length) {
    int w = 0;
    for (int row = starts[count]; row <= ends[count]; row ++) {
      for (int col = 0; col < score.width; col ++) {
        int i = row * score.width + col;
        if (score.pixels[i] == BLUE) {
          int l = getLeft(i);
          int r = getRight(i);
          int u = getUp(i);
          int d = getDown(i);
          int[] blah = crop(l, r, u, d);
          //println(l + ", " + r + ", " + u + ", " + d);
          //if (d - u > 0) {
            //  println(d - u);
          //}
          tester = createImage(r - l, d - u, RGB);
          tester.pixels = blah;
          if (tester.width > 5 && tester.width < 12 && tester.height >= ends[count] - starts[count]) {
            if (count % 2 == 1) { // BASS CLEF
              //notes.add(getNote(tester, 'g'));
            }
            else { // TREBLE CLEF
              //notes.add(getNote(tester, 'b'));
            }
          }
          image(tester, w, 0);
          w = w + tester.height + 5;
          //mark(getRow(i) * score.width + l, 2, YELLOW);
          //mark(getRow(i) * score.width + r, 3, RED);
          //mark(u * score.width + getCol(i), 2, PURPLE);
          //mark(d * score.width + getCol(i), 2, ORANGE);
        }
      }
    }
    count ++;
  }
  count = 0;
  while (count < starts.length) {
    int[] lines = new int[5];
    for (int i = 0; i < lines.length; i ++) {
      lines[i] = staffLines.get(count * 5 + i);
    }
    for (int row = starts[count] - 5; row <= ends[count] + 5; row ++) {
      for (int col = 0; col < score.width; col ++) {
        int i = row * score.width + col;
        if (score.pixels[i] == GREEN || score.pixels[i] == BLUE) {
          int h = 1;
          int tempDown = i, tempUp = i;;
          while (score.pixels[tempDown] == GREEN) {
            h ++;
            tempDown += score.width;
          }
          while (score.pixels[tempUp] == GREEN) {
            h ++;
            tempUp -= score.width;
          }
          if (h < 10) {
            fill(i, GREEN, ORANGE);
            int noteBot = tempDown / score.width;
            if (row <= lines[0] - 3 && noteBot <= lines[0]) {
              notes.add(new Note(79, 0, 1, false));
            }
            else if (row < lines[0] && noteBot >= lines[0]) {
              notes.add(new Note(77, 0, 1, false));
            }
            else if (row <= lines[1] - 3 && noteBot <= lines[1]) {
              notes.add(new Note(76, 0, 1, false));
            }
            else if (row < lines[1] && noteBot >= lines[1]) {
              notes.add(new Note(74, 0, 1, false));
            }
            else if (row <= lines[2] - 3 && noteBot <= lines[2]) {
              notes.add(new Note(72, 0, 1, false));
            }
            else if (row < lines[2] && noteBot >= lines[2]) {
              notes.add(new Note(71, 0, 1, false));
            }
            else if (row <= lines[3] - 3 && noteBot <= lines[3]) {
              notes.add(new Note(69, 0, 1, false));
            }
            else if (row < lines[3] && noteBot >= lines[3]) {
              notes.add(new Note(67, 0, 1, false));
            }
            else if (row <= lines[3] - 3 && noteBot <= lines[3]) {
              notes.add(new Note(65, 0, 1, false));
            }
            else if (row < lines[4] && noteBot >= lines[4]) {
              notes.add(new Note(64, 0, 1, false));
            }
            else if (row >= lines[4]) {
              notes.add(new Note(60, 0, 1, false));
            }
          }
        }
      }
    }
    count ++;
  }
  return notes;
}

void fill(int loc, int replace, int newColor) {
  score.pixels[loc] = newColor;
  int[] colShift = {1, -1, 0, 0};
  int[] rowShift = {0, 0, 1, -1};
  for (int i = 0; i < colShift.length; i ++) {
    int newLoc = (getRow(loc) + rowShift[i]) * score.width + getCol(loc) + colShift[i];
    if (newLoc > -1 && newLoc < score.pixels.length) {
      if (score.pixels[newLoc] == replace) {
        getCols(newLoc, replace, newColor);
      }
    }
  }
}

Note getNote(PImage note, char clef) { // 'g' for treble and 'b' for bass
  //println("New note");
  double linNum; // 0 denotes bottom of the staff, 0.5 denotes space above it
  ArrayList<Integer> staffPos = new ArrayList<Integer>();
  for (int r = 0; r < note.height; r ++) {
    if (note.pixels[r * note.width] == BLACK ||
      note.pixels[r * note.width + note.width - 1] == BLACK) {
      staffPos.add(r);
    }
  }
  for (int i = staffPos.size() - 1; i >= 0; i --) {
    try {
      if (staffPos.get(i) == staffPos.get(i - 1) + 1) {
              staffPos.remove(i);
          }
    }
    catch (ArrayIndexOutOfBoundsException e) {
    }
  }
  int noteTop = -1, noteBase = -1;
  for (int i = 0; i < note.pixels.length; i ++) {
    if (note.pixels[i] == GREEN) {
      try {
        if (note.pixels[i + 1] == GREEN &&
            note.pixels[i + 2] == GREEN &&
            getRow(i) == getRow(i + 1) &&
            getRow(i) == getRow(i + 2)) {
              noteTop = i / note.width;
              break;
            }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = note.pixels.length - 1; i >= 0; i --) {
    if (note.pixels[i] == GREEN) {
      try {
        //print(note.pixels[i - 1] == GREEN);
        if (note.pixels[i - 1] == GREEN) {
              //println(i);
              noteBase = i / note.width;
              break;
            }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  //println(noteTop);
  //println(noteBase);
  //for (int i: staffPos) {
  //  println(i);
  //}
  //background(100);
  //image(note, 1150, 800);
  if (noteTop < staffPos.get(0) && noteBase < staffPos.get(0)) {
    if (clef == 'g') return new Note(79, startBeat ++, endBeat ++, false);
    else return new Note(59, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(0) && noteBase < staffPos.get(1)) {
    if (clef == 'g') return new Note(77, startBeat ++, endBeat ++, false);
    else return new Note(57, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(1) && noteBase < staffPos.get(1)) {
    if (clef == 'g') return new Note(76, startBeat ++, endBeat ++, false);
    else return new Note(55, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(1) && noteBase < staffPos.get(2)) {
    if (clef == 'g') return new Note(74, startBeat ++, endBeat ++, false);
    else return new Note(53, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(2) && noteBase < staffPos.get(2)) {
    if (clef == 'g') return new Note(72, startBeat ++, endBeat ++, false);
    else return new Note(52, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(2) && noteBase < staffPos.get(3)) {
    if (clef == 'g') return new Note(71, startBeat ++, endBeat ++, false);
    else return new Note(50, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(3) && noteBase < staffPos.get(3)) {
    if (clef == 'g') return new Note(69, startBeat ++, endBeat ++, false);
    else return new Note(48, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(3) && noteBase < staffPos.get(4)) {
    if (clef == 'g') return new Note(67, startBeat ++, endBeat ++, false);
    else return new Note(47, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(4) && noteBase < staffPos.get(4)) {
    if (clef == 'g') return new Note(65, startBeat ++, endBeat ++, false);
    else return new Note(45, startBeat ++, endBeat ++, false);
  }
  else if (noteTop < staffPos.get(4)) {
    if (clef == 'g') return new Note(64, startBeat ++, endBeat ++, false);
    else return new Note(43, startBeat ++, endBeat ++, false);
  }
  else {
    if (clef == 'g') return new Note(62, startBeat ++, endBeat ++, false);
    else return new Note(41, startBeat ++, endBeat ++, false);
  }
}


int getLeft(int loc) {
  temp = new ArrayList<Integer>();
  getCols(loc, BLUE, RED);  
  Collections.sort(temp);
  return temp.get(0);
}

int getRight(int loc) {
  temp = new ArrayList<Integer>();
  getCols(loc, RED, ORANGE);  
  Collections.sort(temp);
  return temp.get(temp.size() - 1); 
}

int getUp(int loc) {
  temp = new ArrayList<Integer>();
  getRows(loc, ORANGE, YELLOW);  
  Collections.sort(temp);
  return temp.get(0);   
}

int getDown(int loc) {
  temp = new ArrayList<Integer>();
  getRows(loc, YELLOW, GREEN);  
  Collections.sort(temp);
  return temp.get(temp.size() - 1);   
}

void getCols(int loc, int replace, int newColor) {
  temp.add(getCol(loc));
  score.pixels[loc] = newColor;
  int[] colShift = {1, -1, 0, 0};
  int[] rowShift = {0, 0, 1, -1};
  for (int i = 0; i < colShift.length; i ++) {
    int newLoc = (getRow(loc) + rowShift[i]) * score.width + getCol(loc) + colShift[i];
    if (newLoc > -1 && newLoc < score.pixels.length) {
      if (score.pixels[newLoc] == replace) {
        getCols(newLoc, replace, newColor);
      }
    }
  }
}

void getRows(int loc, int replace, int newColor) {
  temp.add(getRow(loc));
  score.pixels[loc] = newColor;
  int[] colShift = {1, -1, 0, 0};
  int[] rowShift = {0, 0, 1, -1};
  for (int i = 0; i < colShift.length; i ++) {
    int newLoc = (getRow(loc) + rowShift[i]) * score.width + getCol(loc) + colShift[i];
    if (newLoc > -1 && newLoc < score.pixels.length) {
      if (score.pixels[newLoc] == replace) {
        getRows(newLoc, replace, newColor);
      }
    }
  }
}

/*void fill(int loc, int replace1, int newColor) {
  temp = new ArrayList<Integer>();
  score.pixels[loc] = newColor;
  int[] colShift = {1, -1, 0, 0};
  int[] rowShift = {0, 0, 1, -1};
  for (int i = 0; i < colShift.length; i ++) {
    int newLoc = (getRow(loc) + rowShift[i]) * score.width + getCol(loc) + colShift[i];
    if (newLoc > -1 && newLoc < score.pixels.length) {
      if (score.pixels[newLoc] == replace1) {
        fill(newLoc, replace1, newColor);
      }
    }
  }
}*/

int getAkhtual(int x, int y){
    return y*score.width+x;
}

int[] crop(int x1, int x2, int y1, int y2) {
  int[] pixels = new int[(x2 - x1) * (y2 - y1)];
  int i = 0;
  for (int r = y1; r < y2; r ++) {
    for (int c = x1; c < x2; c ++) {
      pixels[i] = score.pixels[r * score.width + c];
      
      /*if (score.pixels[r*score.width+c]==GREEN){
        pixels[i] = BLACK;
      }
      else{
        pixels[i]=WHITE;
      }
      */
      i ++;
    }
  }
  return pixels;
}

int getRow(int i) {
  return i / score.width;
}

int getCol(int i) {
  return i % score.width;
}

void mark(int center, int radius, int hue) {
  if (radius > 0) {
    for (int row = getRow(center) - radius; row <= getRow(center) + radius; row ++) {
      for (int col = getCol(center) - radius; col <= getCol(center) + radius; col ++) {
        try {
          score.pixels[row * score.width + col] = hue;
        }
        catch (ArrayIndexOutOfBoundsException e) {
        }
      }
    }
    score.pixels[center] = BLACK;
  }
  else {
    score.pixels[center] = hue;
  }
}

void draw() {
  //for (int i = 60; i < 128; i ++) {
    //playScale(i, 100);
  //}
  for (Note n: notes) {
    play(n.pitch, (int)(n.beatEnd - n.beatStart) * 500);
  }
  delay(5000);
}

String getNoteString(int i) {
  if (i % 12 == 0) return "C" + "(" + i + ")";
  if (i % 12 == 1) return "C#" + "(" + i + ")";
  if (i % 12 == 2) return "D" + "(" + i + ")";
  if (i % 12 == 3) return "D#" + "(" + i + ")";
  if (i % 12 == 4) return "E" + "(" + i + ")";
  if (i % 12 == 5) return "F" + "(" + i + ")";
  if (i % 12 == 6) return "F#" + "(" + i + ")";
  if (i % 12 == 7) return "G" + "(" + i + ")";
  if (i % 12 == 8) return "G#" + "(" + i + ")";
  if (i % 12 == 9) return "A" + "(" + i + ")";
  if (i % 12 == 10) return "A#" + "(" + i + ")";
  return "B" + "(" + i + ")";
}

void playScale(int i, int time) {
  play(i, time);
  i += 2;
  play(i, time);
  i += 2;
  play(i, time);
  i += 1;
  play(i, time);
  i += 2;
  play(i, time);
  i += 2;
  play(i, time);
  i += 2;
  play(i, time);
  i += 1;
  play(i, time);
}

void play(int i, int time) {
  //println(getNoteString(i));
  midiChannel[0].noteOn(i, 100);
  delay(time);
  midiChannel[0].noteOff(i);
}