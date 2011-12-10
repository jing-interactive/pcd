final int no_data = 0;
final int new_msg_mode = 1;
final int idle_mode = 2;
final int wall_mode = 3;
final int award_mode = 4;

int app_mode = wall_mode;

void FSM_draw()
{
  if (keyPressed)
  {
    if (key ==' ')
    {
      award_setup();
    }
    else
    {
      wall_setup();
    }
  }
}

