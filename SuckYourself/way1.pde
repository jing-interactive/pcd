int suck_idx = 0, new_suck_idx = 0;
int n_keys = 0;
int n_reqs[] = {
  0, 8, 16, 32, 60, 96, 160, 220,
};

void way1_setup()
{
  state = way1;
  bg = field;
  noCursor();
  suck_idx = new_suck_idx = 0;
  n_keys = 0;
}

void keyReleased()
{
  n_keys ++;
  for (int i=0;i<n_suck_anims;i++)
  {
    if (n_keys >= n_reqs[i])
    {
      new_suck_idx = i;
    }
  }
}

void way1()
{
  if (suck_idx != new_suck_idx)
  {
    suck_idx = new_suck_idx;
    minim_play(growup);
  }
  if (n_keys > 230)
  {
    win_setup();
  }
  else
  {
    image(suck_ani[suck_idx], 428, 499);

    float h = n_keys/220.0f;
    pushStyle();
    noStroke();
    fill(255, 0, 0, 55+h*200);
    rect(10, 80, h*(width-120), 30);
    popStyle();
  }
}

