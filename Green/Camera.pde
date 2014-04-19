import processing.video.*;

Capture cam;

void setupCamera()
{
  println("opening camera");
  if (DEBUG_CAMERA)
  {
    String[] cameras = Capture.list();

    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++)
    {
      println(cameras[i]);
    }
  }

  cam = new Capture(this, kCamWidth, kCamHeight, kCamName, 30);
  cam.start();
}

void drawCamera()
{
  if (cam.available())
  {
    cam.read();
  }  
  image(cam, 0, 0, displayWidth, displayHeight);
}

