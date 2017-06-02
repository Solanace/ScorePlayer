class Note {
    double freq, beatStart, beatEnd;
    boolean isRest;
    
    public Note(double frequency, double start, double end) {
        freq=frequency;
        beatStart=start;
        beatEnd=end;
    }
}