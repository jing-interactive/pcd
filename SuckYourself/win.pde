float rot = 0;

void win_setup()
{
  state = win;
  setTimer();
  minim_play(high);
  bg = null;
  rot = 0;
  textAlign(CENTER);
}

void win()
{
  if (getElapsed() > 4000)
  {
    menu_setup();
    return;
  }
  background(0);
  //  rect(0,0,width,height);
  fill(255);
  pushMatrix();
  translate(width/2, height/2);
  rot++;
  scale(rot*0.02);
  rotate(rot*0.015);
  text("Good job!", 0, 0);
  popMatrix();
}

