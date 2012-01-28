PImage menu0, menu1, menu2, our;
PImage room, field;
PImage bg;
PImage spirit_sheet, stand, stand_suck;
PImage raw_jiba, jiba1, jiba2;
PImage dark;
final int n_suck_anims = 8;
PImage suck_ani[] = new PImage[n_suck_anims];

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
  our = loadImage("Ouroboros.preview.png");
  PImageResize(our, 0.3);

  room = loadImage("room.png");
  field = loadImage("field.png");  
  spirit_sheet = loadImage("jibajiang_2.png");
  stand = spirit_sheet.get(43, 43, 229-43, 318-43);
  stand_suck = spirit_sheet.get(586, 22, 229-43, 318-43);

  raw_jiba = loadImage("Jiba.png");
  jiba1 = raw_jiba.get(200, 137, 193, 399);
  PImageResize(jiba1, 0.1);
  jiba1.filter(DILATE);
  jiba1.filter(BLUR);

  jiba2 = raw_jiba.get(475, 271, 257, 240);
  PImageResize(jiba2, 0.1);
  jiba2.filter(DILATE);
  jiba2.filter(BLUR);

  //anim
  for (int i=0;i<n_suck_anims;i++)
  {
    suck_ani[i] = loadImage("suck_"+i+".png");
    PImageResize(suck_ani[i],0.7);
  }
}

