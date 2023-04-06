Blob[] blobs = new Blob[10];

void setup() {
  size(960, 540);
  colorMode(HSB);
  for( int i = 0; i< blobs.length; i++) {
     float x = random(width);
     float y = random(height);
     blobs[i] = new Blob(x, y); 
  }
}

void draw() {
 background(51);
 
  loadPixels();
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) { 
      int index = x + y * width;
      float sum = 0;
      for(Blob b : blobs) {  
        float d = dist(x, y, b.pos.x, b.pos.y); 
        sum += 100 * blobs[0].r / d;
     }
     pixels[index] = color(constrain(sum, 0, 220), 255, 255);
    }
 }
 updatePixels();
  
  for(int i = 0; i < blobs.length; i++) {
    blobs[i].update();
    //blobs[i].show();
  }
}
