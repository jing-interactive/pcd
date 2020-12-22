void setup()
{
  PImage img = loadImage("shadow.png");
  for (int x=0; x<img.width; x++)
    for (int y=0; y<img.height; y++)
    {
      color clr = img.pixels[y*img.width+x];
      float r = red(clr);
      float g = green(clr);
      float b = blue(clr);
      float a = alpha(clr);

      float v = r*255*255*255+g*255*255+b*255+a;
      v *= (255.0f / 4294967295L);
      //println(v);
      img.set(x, y, color(v));
    }

  img.save("resolved.png");

  exit();
}
