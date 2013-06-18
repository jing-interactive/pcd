Profile[] profiles;

void winner_setup()
{
  if (team_mode)
  {
    profiles = new Profile[2];
  }
  else
  {
    profiles = new Profile[10];
  }
  for (int i=0;i<profiles.length;i++)
    profiles[i] = new Profile(name_list[i], miles_list[i]);  
  Arrays.sort(profiles);
  millis_reset();
  status = winner;
}

void winner_draw()
{
  fill(255);
  cnFont(60);
  text(profiles[0].name, 386, 385);
  enFont(66);
  text(to_km(profiles[0].miles), 569, 391);
}

