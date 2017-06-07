class ImageComparer{
  PImage one;
  PImage two;
  
  ImageComparer(String first, String second){
    one=loadImage(first);
    two=loadImage(second);
  }
  
  int compare(){//returns percent dissimilar
    two.resize(one.width,one.height);
    one.filter(THRESHOLD);
    two.filter(THRESHOLD);
    int percent=0;
    for (int c=one.width-1; c>-1; c--){
      for (int r=one.height-1; r>-1; r--){
         if (one.pixels[r*one.width+c] != two.pixels[r*one.width+c]){
           percent++;
         }
      }
    }
    return percent/(one.width*one.height);
  }
  
  void setOne(String first){
    one=loadImage(first);
  }
  
  void setTwo(String second){
    two=loadImage(second);
  }
  
  void setTwo(String first, String second){
    one=loadImage(first);
    two=loadImage(second);
  }
}