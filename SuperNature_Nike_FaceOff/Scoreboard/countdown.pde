int count_left, count_right;
AniSequence countdown_seq;

void countdown_setup()
{
  count_left = count_right = 0;
}

void countdown_draw()
{
  float e = elapsed();
  if (e >= 1)
  {
    if (e-(int)e < 0.5 || e >= 6)
    {
      imageMode(CENTER);
      image(six_number[6-(int)e], width/2, height/2);
    }
    else
    {
      rectMode(CENTER);
      noFill();
      stroke(green_main);
      rect(width/2+random(-20, 20), height/2+random(-20, 20), random(20, 80), random(20, 80));
    }
  }
  if (e < 6)
  {
    imageMode(CORNER);
    image(left_fly_count, count_left-left_fly_count.width, Height*0.45);
    image(right_fly_count, width-count_right, Height*0.45);
  }
}

