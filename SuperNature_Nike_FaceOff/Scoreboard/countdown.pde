int count_left, count_right;
AniSequence countdown_seq;

void countdown_setup()
{
  count_left = count_right = 0;
  countdown_seq.start();
  millis_reset();
  status = countdown;
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
      if (false)
      {
        rectMode(CORNER);
        noFill();
        strokeWeight(4);
        //rect(width/2+random(-20, 20), height/2+random(-20, 20), random(20, 80), random(20, 80));
        float x = width/2+random(-20, 20), y = height/2+random(-20, 20);      
        stroke(green_main);
        line(x - random(40, 100), y, x+ random(40, 100), y);
        stroke(blue_main);
        line(x, y-random(40, 100), x, y+random(40, 100));
      }
    }
  }
  if (e < 6)
  {
    imageMode(CORNER);
    image(left_fly_count, count_left-left_fly_count.width, Height*0.45);
    image(right_fly_count, width-count_right, Height*0.45);

    if (team_mode)
    {
      int bdy = 28;
      fill(blue_name);
      text(name_list[0], count_left-left_fly_count.width+50, 529*YScale+bdy);
      fill(green_name);
      text(name_list[1], width-count_right+130, 529*YScale+bdy);
    }
  }
}

