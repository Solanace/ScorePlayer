class Note {
    int pitch;
    long beatStart, beatEnd;
    boolean isRest;
    
    Note(int pitch, long start, long end, boolean rest) {
        this.pitch = pitch;
        beatStart = start;
        beatEnd = end;
        isRest=rest;
    }
    
    public String toString() {
      return pitch + ", " + beatStart + ", " + beatEnd;
    }
}