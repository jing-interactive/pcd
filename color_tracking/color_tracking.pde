import codeanticode.gsvideo.*;

Detector bs;
GSCapture cam;
PImage img;

final int SCALE = 2;
final int W = 640;
final int H = 480;

void setup()
{
  // Size of applet
  size(W, H);
  rectMode(CORNERS);
  ellipseMode(CORNERS);

  // Capture
  cam = new GSCapture(this, W/SCALE, H/SCALE);
  cam.start();

  // BlobDetection
  img = new PImage(cam.width, cam.height); 
  bs = new Detector(this, 0, 0, cam.width, cam.height, 255);
  stroke(255, 0, 0, 150);
  strokeWeight(3);
  noFill();
}

void draw()
{ 
  if (cam.available() == true)
  {
    cam.read();
    image(cam, 0, 0, width, height);
    img.copy(cam, 0, 0, cam.width, cam.height, 
      0, 0, img.width, img.height);
      
    img.loadPixels();
    for (int i = 0; i < img.width*img.height; i++) {
      int pixelColor = img.pixels[i];
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      //通过if语句限制要跟踪的颜色的范围
      if (r > 150 && r < 220 && g > 100 && b < 50)
        img.pixels[i] = 255;
      else
        img.pixels[i] = 0;
    }
    
    img.updatePixels();    
    bs.imageFindBlobs(img);
    bs.loadBlobsFeatures();

    int n_blobs = bs.getBlobsNumber();
    PVector[] A = bs.getA();
    PVector[] D = bs.getD();
    println(A);
    for (int i=0;i<n_blobs;i++)
    {
      ellipse(A[i].x*SCALE, A[i].y*SCALE, D[i].x*SCALE, D[i].y*SCALE);
    }
  }
}

