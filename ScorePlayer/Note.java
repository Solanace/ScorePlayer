class Note {
    int freq;
    double beatStart, beatEnd;
    boolean isRest;
    
    Note(int frequency, double start, double end) {
        freq = frequency;
        beatStart = start;
        beatEnd = end;
    }
    
    public String toString() {
      return freq + ", " + beatStart + ", " + beatEnd;
    }
}