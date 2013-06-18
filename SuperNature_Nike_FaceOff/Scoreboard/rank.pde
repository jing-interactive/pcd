class Profile implements Comparable {
  String name;
  int miles;
  Profile(String n, int m) {
    name = n;
    miles = m;
  }
  int compareTo(Object o)
  {
    Profile other=(Profile)o;
    if (other.miles>miles)  
      return 1;
    if (other.miles==miles)
      return 0;
    else
      return -1;
  }
}

void rank_setup()
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
  status = rank;
}

void rank_draw()
{
  int n = 5;
  if (team_mode)
    n = 2;
  final int y0 = 251;
  final int dy = 120;

  {//winner position
    image(banner_winner, 0, y0);
    fill(250, 250, 8);
    cnFont(32);
    text(profiles[0].name, 301, 304); 
    enFont(43);
    text(to_km(profiles[0].miles), 786, 304);
    enFont(30);
    fill(0);
    text("1",60,309);
  }

  for (int i=1;i<n;i++)
  {
    image(banner_normal, 0, y0+81*i);
    fill(255,255,255);
    cnFont(30);
    text(profiles[i].name, 301, 392+83*(i-1)); 
    enFont(35);
    text(to_km(profiles[i].miles), 786, 392+83*(i-1));
    enFont(30);
    fill(0);
    text(i+1,60,386+83*(i-1));    
  }
  println(mouseX+","+mouseY);
}

