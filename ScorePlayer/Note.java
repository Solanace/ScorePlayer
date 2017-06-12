class Note {
    int freq;
    long beatStart, beatEnd;
    boolean isRest;
    
    Note(int frequency, long start, long end, boolean rest) {
        freq = frequency;
        beatStart = start;
        beatEnd = end;
        isRest=rest;
    }
    
    public String toString() {
      return freq + ", " + beatStart + ", " + beatEnd;
    }
}