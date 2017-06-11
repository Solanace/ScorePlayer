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
Instrument piano;

int tempo;
ArrayList<Note> notes;

void setup(){
  size(800, 400);
  try {
    frameRate(60);
    score = loadImage("twinkle2.png");
    score.loadPixels();
    blackbody(score);
    
    synthesizer=MidiSystem.getSynthesizer();
    synthesizer.open();
    midiChannel = synthesizer.getChannels();
    instruments = synthesizer.getDefaultSoundbank().getInstruments();
    piano=instruments[0];
    synthesizer.loadInstrument(piano);
    midiChannel[0].setMono(false);
    
    //this will go into getNotes(PImage) later
    ArrayList<Integer> staffPositions = getStaffPositions();
    for (int i : staffPositions) {
      int j = getTop(i);
      int staffHeight = getStaffHeight(i);
      mark(i, 3, BLUE);
      mark(j, 3, PURPLE);
      mark(j + staffHeight * score.width, 2, RED);
      mark(getLeft(i), 3, YELLOW);
      mark(getLeft(j), 3, GREEN);
    }
  }
  catch (MidiUnavailableException e) {
    print(e);
  }
}

void draw() {
  background(0);
  image(score, 0, 0);
  try{
    play(midiChannel);
  }
  catch(MidiUnavailableException e){
    println("idk wtf is going on");
  }
}

int getRow(int pixel) {
  return pixel / score.width;
}

int getCol(int pixel) {
  return pixel % score.width;
}

void mark(int center, int radius, int hue) {
  for (int row = getRow(center) - radius; row <= getRow(center) + radius; row ++) {
    for (int col = getCol(center) - radius; col <= getCol(center) + radius; col ++) {
      // System.out.println(row * score.width + col);
      score.pixels[row * score.width + col] = hue;
    }
  }
  score.pixels[center] = BLACK;
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

ArrayList<Integer> getStaffPositions() { // bottom right pixel of each staff
  ArrayList<Integer> staffPositions = new ArrayList<Integer>();
  int i = getLast();
  staffPositions.add(getLast());
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
  return staffPositions;
}

int getStaffHeight(int i) { // i is an int in staffPositions
  int j = getTop(i);
  return getRow(i - j);
}

int getTop(int i) {
  while (i >= 0 && score.pixels[i] != WHITE) {
    i -= score.width;
  }
  while (score.pixels[i - 5] != BLACK) {
    i += score.width;
  }
  return i;
}

int getLeft(int i) {
  while (i >= 0 && score.pixels[i] != WHITE) {
    i --;
  }
  return i + 1;
}

/////////////////////////////// THE CORE FUNCTION THAT CAN POTENTIALLY BE PUT IN ANOTHER CLASS
void play(MidiChannel[] midiChannel) throws MidiUnavailableException{
  ArrayList<Note> noteEnds=new ArrayList<Note>;
  long startTime=System.currentTimeMillis();
  while (notes.size()!=0){
    long currentTime=System.currentTimeMillis()-startTime;
    Note currentNote=notes.remove(0);
    while(currentNote.beatStart==System.currentTimeMillis()){
      noteEnds.add(currentNote);
      midiChannel[0].noteOn(currentNote.freq,50);
      currentNote=notes.remove(0);
    }
    Note currentEndNote=noteEnds.remove(0);
    while(currentEndNote.beatEnd==System.currentTimeMillis()){
      midiChannel[0].noteOff(currentEndNote.freq);
      currentEndNote=noteEnds.remove(0);
    }
  }
}