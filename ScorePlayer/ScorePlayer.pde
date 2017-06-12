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
int staffHeight;
boolean doubleClef;

void setup(){
  size(1200, 2500);
  //frameRate(1);
  score = loadImage("MarchWind.png");//////////////////////////////////////////////////////////////////////////////////////////////
  //score.resize(score.width*3/2,score.height*3/2);
  cleanse();
  highlightBetween();
  blackenStaffLines();
  bluifyNotes();
 // println(""+score.width+" "+score.height);
  score.loadPixels();
  
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
///////////////////////////////////////
void staffHeight(){
  int i=0;
  while (!approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenClefs) && !approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenStaves)){
    i++;
  }
  staffHeight=staffLines.get(i-1)-staffLines.get(0);
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

void draw() {
  background(0);
  image(score, 0, 0);
  //play();
}

void play() {
  midiChannel[0].noteOn(60, 100);
  midiChannel[0].noteOff(60, 100);
}