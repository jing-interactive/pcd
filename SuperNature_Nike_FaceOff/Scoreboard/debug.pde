boolean debug = true;
boolean team_mode = false;

void debug_name_list_setup()
{
  if (debug)
  {
    for (int i=0;i<10;i++)
      name_list[i] = "张某_"+i;
  }
}

