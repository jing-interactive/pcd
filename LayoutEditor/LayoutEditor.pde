import sojamo.drop.*;
boolean first_drop = true;
PImage bg = null;

SDrop drop;

class UIElement
{
  PImage img;
  PVector pos = new PVector();
  UIElement(PImage _img, float x, float y)
  {
    img = _img;
    pos.x = x;
    pos.y = y;
    pos.z = 0;
  }
  //(x,y)是否在图片范围内
  boolean isPointInside(float x, float y)
  {
//    x -= pos.x;
 //   y -= pos.y;
    return (x > 0 && x < img.width && y>0 && y<img.height);
  }
  void move(float x, float y)
  {
    pos.x = x;
    pos.y = y;
  }
  void draw()
  {
    image(img, pos.x, pos.y);
  }
  void save(String filename)
  {
  }
  void load(String filename)
  {
  }
}
ArrayList<UIElement> elements = new ArrayList<UIElement>();

void setup() {
  size(1280, 800);
  frameRate(30);
  drop = new SDrop(this);
  imageMode(CORNER);
  frame.setResizable(true);
  bg = loadImage("e:\\__svn_pool\\Minhang\\_AndroidApp\\RemoteCtrl_Tianjing\\res\\drawable-mdpi\\bg_load.png");
}

boolean dragging = false;
UIElement active = null;

void mouseMoved()
{
  if (active != null)
    active.move(mouseX, mouseY);
}

void mouseReleased()
{
  println("d");
  if (!dragging)
  {
    dragging = true;
    for (UIElement e: elements)
    {
      if (e.isPointInside(mouseX, mouseY))
      {
        active = e;
        break;
      }
    }
  }
  else
  {
    dragging = false;
    active = null;
  }
}

void draw() {
  if (bg == null)
    background(0);
  else
    image(bg, 0, 0);

  for (UIElement e: elements)
    e.draw();
}

void dropEvent(DropEvent event) {
  // if the dropped object is an image, then 
  // load the image into our PImage.
  if (event.isImage()) {
    println("### loading image ...");
    PImage m = event.loadImage();
    if (bg == null)
    {//set the bg
//      size(bg.width, bg.height); 
  //    frame.setSize(bg.width, bg.height);

      bg = m;
    }
    else
    {
      elements.add(new UIElement(m, event.x(), event.y()));
    }
  }
}

