class ImageComparer{
  
   double compare(PImage one, PImage two){//returns percent dissimilar
    if (one.width*one.height>two.width*two.height){
      one.resize(two.width,two.height);
    }
    else{
      two.resize(one.width,one.height);
    }
    one.filter(THRESHOLD);
    two.filter(THRESHOLD);
    double percent=0;
    for (int c=one.width-1; c>-1; c--){
      for (int r=one.height-1; r>-1; r--){
         if (one.pixels[r*one.width+c] != two.pixels[r*one.width+c]){
           percent++;
         }
      }
    }
    return percent/(one.width*one.height);
  }
}