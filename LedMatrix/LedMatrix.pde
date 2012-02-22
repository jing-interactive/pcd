final int W = 8;
final int H = 7;
final int Z = 45;
final int KX = 40;//间隔X
final int KY = 40;//间隔Y
final int KZ = 20;//间隔Z
final int S = 10;//尺寸
final int TOTAL = W*H*Z;

void setup()
{
  size(800, 600, P3D);
  colorMode(HSB, 360, 100, 100);
  peasy_setup();
//  gui_setup();
  noStroke();
  led_setup();
  spark_setup();
  kinect_setup();
}

float millis = 0;
void draw()
{
  millis = millis();
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  background(0, 100, 0);
  translate(-W*KX/2, -H*KY/2, -Z*KZ/2);
  fsm();
  led_draw();
  if (keyPressed && key == ' ')
    saveFrame("led-####.tif");
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}

