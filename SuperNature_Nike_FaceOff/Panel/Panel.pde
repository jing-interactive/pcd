import oscP5.*;
import netP5.*;
//import processing.opengl.*;
//import codeanticode.glgraphics.*;

OscP5 oscP5; 

final int OneW = 96;
final int OneH = 96*4;
final int Width = OneW*10;
final int Height = OneH;

OnePanel[] panels = new OnePanel[10]; 
PFont font;
//GLGraphicsOffScreen pg2;
//GLTexture tex1;
final int pg_scale = 2;

void setup() 
{
  size(Width, Height, P2D); 
  frameRate(30);
  font = loadFont("BrowalliaUPC-Bold-96.vlw");
  oscP5 = new OscP5(this, 3334);
 // pg2 = new GLGraphicsOffScreen(this, Width/pg_scale, Height/pg_scale);    
 // tex1 = new GLTexture(this, pg2.width, pg2.height);  
  for (int i=0;i<10;i++)
  {
    panels[i] = new OnePanel(i);
  }
}

int millis = 0;

void draw() 
{
  if (frameCount % 30 == 0)
    println(frameRate);
  millis = millis();
  background(0);
  for (int i=0;i<10;i++)
    panels[i].draw();
  //pg2_draw();
  //  if (debug)
  //    println(frameRate);
}

void oscEvent(OscMessage msg) 
{
  String patt = msg.addrPattern();
  println(patt);
  if (patt.equals("/msg"))
  {
    if (msg.checkTypetag("iii"))
    {
      int id = msg.get(0).intValue();
      int speed = msg.get(1).intValue();
      int miles = msg.get(2).intValue();
      panels[id].update(speed, miles);
    }
  }
  else if (patt.equals("/start"))
  { 
    println(patt);
    for (int i=0;i<10;i++)
      panels[i].reset();
  }
}

/*
void pg2_draw()
{
  tex1.loadPixels();
  for (int i=0;i<10;i++)
  {
    panels[i].pg2_update();
  }
  tex1.loadTexture();
  image(tex1, 0, 0, width, height);
}*/
