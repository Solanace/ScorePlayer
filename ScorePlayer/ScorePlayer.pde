import javax.sound.midi.*;
PImage score;
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
ArrayList<Integer> staffLines;
int spaceBetweenStaves;
int spaceBetweenClefs;
boolean doubleClef;

void setup(){
  size(2000, 3000);
  //frameRate(1);
  score = loadImage("MarchWind.png");//////////////////////////////////////////////////////////////////////////////////////////////
  //score.resize(score.width/2,score.height/2);
  cleanse();
  highlightBetween();
 // println(""+score.width+" "+score.height);
  score.loadPixels();
  /*
  //blackbody(score);
  //score.filter(THRESHOLD);
  //this will go into getNotes(PImage) later
  ArrayList<Integer> staffPositions = getStaffPositions();
  for (int i = 0; i < staffPositions.size(); i ++) {
    //System.out.println(i);
    int botRight = staffPositions.get(i);
    int botLeft = getLeft(botRight);
    int topRight = getTop(botRight);
    int topLeft = getLeft(topRight);
    int staffHeight = getStaffHeight(botRight);
    int staffLength = getStaffLength(botRight);
    ArrayList<Integer> staffLines = getStaffLines(botRight);
    
    for (int c = getCol(topLeft); c < getCol(topRight); c ++) {
      for (int r = staffLines.get(0); r < staffLines.get(staffLines.size() - 1); r ++) { // not topLeft and botLeft because of ledger lines
        int pixel = r * score.width + c;
        try{
        if (isNotOnLine(pixel, staffLines) && score.pixels[pixel] != WHITE) {// the score.pixels[pixel] (2nd clause) part is causing the problem
          mark(r * score.width + c, 0, BLUE);
        }
        }
        catch (ArrayIndexOutOfBoundsException e){/*println("line 42");}
      }
    }
    
    mark(botRight, 3, BLUE);
    mark(topRight, 3, PURPLE);
    mark(topRight + staffHeight * score.width, 2, RED);
    mark(botLeft, 3, YELLOW);
    mark(topLeft, 3, GREEN);
    for (int row : staffLines) {
      mark(row * score.width, 0, ORANGE);
    }
    
  }*/
  
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
    println(staffLines.get(i));
  }
  spaceBetweenStaves=maximum(staffLines);
  secondMaximum(staffLines, spaceBetweenStaves);
  if (doubleClef){
    spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
    println("space between clefs: "+spaceBetweenClefs);
  }
  spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
  println("space between: "+spaceBetweenStaves);
}

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

boolean approx(int x, int y){
  if ((Math.abs(x-y)/y)<0.05){
    return true;
  }
  return false;
}

void highlightLine(int x){
  for (int i=0; i<score.width; i++){
    if (score.pixels[x*score.width+i]!=WHITE){
      score.pixels[x*score.width+i]=BLUE;
    }
  }
}

void draw() {
  background(0);
  image(score, 0, 0);
  //play();
}

void play() {
  midiChannel[0].noteOn(60, 100);
  midiChannel[0].noteOff(60, 100);
}

int getRow(int pixel) {
  return pixel / score.width;
}

int getCol(int pixel) {
  return pixel % score.width;
}

void mark(int center, int radius, int hue) {
  if (radius > 0) {
    for (int row = getRow(center) - radius; row <= getRow(center) + radius; row ++) {
      for (int col = getCol(center) - radius; col <= getCol(center) + radius; col ++) {
        // System.out.println(row * score.width + col);
        try{
        score.pixels[row * score.width + col] = hue;
        }
        catch (ArrayIndexOutOfBoundsException e){/*println("line 92");*/}
      }
    }
    try{score.pixels[center] = BLACK;}
    catch (ArrayIndexOutOfBoundsException e){/*println("line 96");*/}
  }
  else {
    score.pixels[center] = hue;////////////////////////////////////////////////
  }
}

void whitewash(PImage score) {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] != BLACK) {
      score.pixels[i] = WHITE;
    }
  }
}

void blackbody(PImage score) {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] != WHITE) {
      score.pixels[i] = BLACK;
    }
  }
}

int getLast() {
  for (int col = score.width - 1; col > 0; col --) {
    for (int row = score.height - 1; row > 0; row --) {
      if (score.pixels[row * score.width + col] != WHITE) {
        return row * score.width + col;
      }
    }
  }
  throw new IndexOutOfBoundsException();
}

int getTop(int i) {
  while (i >= 0 && score.pixels[i] != WHITE) {
    i -= score.width;
  }try{
  while (score.pixels[i - 5] != BLACK) {
    i += score.width;
  }
  }
  catch (ArrayIndexOutOfBoundsException e){/*println("line 134");*/}
  return i;
}

int getLeft(int i) {
  try{
  while (i >= 0 && score.pixels[i] != WHITE) {
    i --;
  }
  }
  catch (ArrayIndexOutOfBoundsException e){/*println("line 144");*/}
  return i + 1;
}

ArrayList<Integer> getStaffPositions() { // bottom right pixel of each staff
  ArrayList<Integer> staffPositions = new ArrayList<Integer>();
  int i = getLast();
  staffPositions.add(getLast());
  try{
  while (i >= 0) {
    while (score.pixels[i] != WHITE) {
      i -= score.width;
    }
    while (i >= 0 && score.pixels[i] != BLACK) {
      i -= score.width;
    }
    if (i >= 0) {
      staffPositions.add(i);
    }
  }
  }
  catch(ArrayIndexOutOfBoundsException e){println("line 213");}
  return staffPositions;
}

int getStaffHeight(int i) { // i is an int in staffPositions
  int j = getTop(i);
  return getRow(i - j);
}

int getStaffLength(int i) { // i is an int in staffPositions
  int j = getLeft(i);
  return getCol(i - j);
}

ArrayList<Integer> getStaffLines(int i) { // i is an int in staffPositions
  ArrayList<Integer> staffLines = new ArrayList<Integer>();
  int top = getRow(getTop(i));
  int botLeft = getLeft(i);
  int pixel = botLeft + 2; // to counter uneven edges
  int h = getStaffSpace(i);
  staffLines.add(top - 2 * h);
  staffLines.add(top - 1 * h);
  try{
  while (getRow(pixel) >= top) {
    if (score.pixels[pixel] != WHITE) {
      staffLines.add(getRow(pixel));
    }
    pixel -= score.width;
  }
  }
  catch(ArrayIndexOutOfBoundsException e){println ("line 243");}
  staffLines.add(getRow(botLeft) + 1 * h);
  staffLines.add(getRow(botLeft) + 2 * h);
  return staffLines;
}

int getStaffSpace(int i) {
  int pixel = getLeft(i) + 2;
  int h = 0;
    try{
  while (score.pixels[pixel] != WHITE) {
    h ++;
    pixel -= score.width;
  }
  while (score.pixels[pixel] != BLACK) {
    h ++;
    pixel -= score.width;
  }
  }
  catch (ArrayIndexOutOfBoundsException e){/*println("line 207");*/}
  //println(h);
  return h;
}

int moveUp(int i) { // i is any staff line except for the top of the top staff
  int botLeft = getLeft(i);
  int colShift = i - getLeft(i);
  i = botLeft;
  while (i >= 0 && score.pixels[i] != WHITE) {
    i -= score.width;
  }
  while (i >= 0 && score.pixels[i] != BLACK) {
    i -= score.width;
  }
  return i + colShift;
}

int moveDown(int i) {
  int botLeft = getLeft(i);
  int colShift = i - botLeft;
  i = botLeft;
  while (i >= 0 && score.pixels[i] != WHITE) {
    i += score.width;
  }
  while (i >= 0 && score.pixels[i] != BLACK) {
    i += score.width;
  }
  return i + colShift;
}

boolean isNotOnLine(int pixel, ArrayList<Integer> staffLines) {
  for (int i : staffLines) {
    if (getRow(pixel) == i) {
      return false;
    }
  }
  return true;
}

/*int getStart(int botRight, int i) {
  if (i == 0) THIS HAS TIME SIGNATURE*/