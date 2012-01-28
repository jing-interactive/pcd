PImage menu0,menu1,menu2,our;
PImage room,field;
PImage bg;

void PImageResize(PImage in, float kx, float ky)
{
  in.resize(int(in.width*kx), int(in.height*ky) );
}

void PImageResize(PImage in, float k)
{
  PImageResize(in, k, k);
}

void image_setup()
{
  menu0 = loadImage("menu0.png");
  menu1 = loadImage("menu1.png");
  menu2 = loadImage("menu2.png");
  room = loadImage("room.png");
  field = loadImage("field.png");
  
  our = loadImage("Ouroboros.preview.png");
  PImageResize(our, 0.3);
}
