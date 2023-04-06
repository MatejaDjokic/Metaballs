import processing.video.*;

Capture video;

color trackColor;
float threshold = 80;
float distThreshold = 75;

ArrayList<Blob> blobs = new ArrayList<Blob>();

boolean showMeta = false;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  trackColor = color(228, 67, 88);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold += 5;
  } else if (key == 'z') {
    distThreshold -= 5;
  }
  if(key == ' ') {
    showMeta = !showMeta;
  }

  println(distThreshold);
}

void draw() {
  video.loadPixels();
  push();
  scale(-1, 1);
  translate(-width, 0);
  image(video, 0, 0);
  pop();
  blobs.clear();

  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y * video.width;

      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      if (d < threshold * threshold) {
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  push();scale(-1, 1);
  translate(-width, 0);
  if (showMeta) {
    colorMode(HSB);
    loadPixels();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int index = x + y * width;
        float sum = 0;
        for (Blob b : blobs) {
          float d = dist(x, y, b.getX(), b.getY());
          sum += b.size() / d / 10;
        }
        pixels[index] = color(constrain(sum, 0, 255), 255, 255);
      }
    }

    updatePixels();
    colorMode(RGB);
  }
  pop();
  
  for (Blob b : blobs) {
    if (b.size() > 500) {
      if(!showMeta) {
        b.show();
      }
    }
  }

  textAlign(RIGHT);
  fill(255);
  text("distance threshold: " + distThreshold, width - 10, 30);
  text("color threshold: " +  threshold, width - 10, 50);
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1);
  return d;
}
