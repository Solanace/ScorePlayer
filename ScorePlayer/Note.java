class Note {
    double freq, beatStart, beatEnd;
    boolean isRest;
    
    Note(double frequency, double start, double end) {
        freq = frequency;
        beatStart = start;
        beatEnd = end;
    }
    
    public String toString() {
      return freq + ", " + beatStart + ", " + beatEnd;
    }
}