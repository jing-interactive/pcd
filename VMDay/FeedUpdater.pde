final int refresh_time_count = 30*1000;//refresh every 30 seconds
final String delim = "<|>";


class Profile
{
  void setup(String name, String icon_url)
  { 
    name_ = name;
    post_ = 1;
    icon_url_ = icon_url;
    if (icon_url_ != null)
    {
      small_ = loadImage(icon_url, "jpg");
      if (small_ == null)
        small_ = default_small;
      PImage_resize(small_, 0.6);
      String big_url = icon_url.replaceAll("\\/50\\/", "/180/");
      big_ = loadImage(big_url, "jpg");
      if (big_ == null)
        big_ = default_big;
    }
  }

  Profile(String name, String icon_url)
  {
    setup(name, icon_url);
  }

  Profile(String fromString)
  {
    String[] list = split(fromString, delim);
    name_ = list[0];
    icon_url_ = list[1];
    post_ = int(list[2]);
    setup(name_, icon_url_);
  }

  String toString()
  {
    return name_+delim+icon_url_+delim+post_;
  }

  color clr_ = color(random(30,150), random(30,150), random(30,150));
  String name_, icon_url_;
  PImage small_, big_;
  int post_;
}
HashMap<String, Profile> g_profiles = new HashMap<String, Profile>();

class FeedUpdater extends Thread
{
  String query_;
  HashMap<String, Phrase> msgs_ = new HashMap<String, Phrase>();
  float mls = -1000000;//to enable first crawl

  FeedUpdater(String query)
  {
    query_ = query;
  }

  boolean dataChanged = false;

  boolean isDataUpdated()
  {
    return dataChanged;
  }

  ArrayList<Phrase> getData()
  {
    //lock msgs_
    dataChanged = false;
    // ArrayList<Phrase> ret = new ArrayList<Phrase>();
    Object[] arr = msgs_.values().toArray();
    println(msgs_.size());

    ArrayList<Phrase> ret = new ArrayList<Phrase>(arr.length);
    println(arr.length);
    for (int i=arr.length-1;i>=0;i--)
    {
      ret.add((Phrase)arr[i]);
    }
    //unlock msgs_; 
    return ret;
  }

  void parseXML(String query, ArrayList list)
  {
    doParseXML("http://api.t.sina.com.cn/statuses/search.xml?source=3709681010&q="+query, list);
    //doParseXML("http://api.t.sina.com.cn/trends/statuses.xml?source=3709681010&trend_name="+query, list);
  }

  void doParseXML(String input, ArrayList list)
  {  
    list.clear();
    XML xml = loadXML(input);
    if (xml == null)
      return;

    XML searchResult = xml.getChild(0);
    if (searchResult != null)
      xml = searchResult;
    else
      return;
    int n_xml = xml.getChildCount();
    for (int i = 0; i< n_xml; i++)
    {
      XML phrase = xml.getChild(i);
      XML id = phrase.getChild("id");
      if (id == null)
        continue;
      String mid = id.getContent(); 
      if (debug_feed) 
        println(mid);

      if (!mid.equals("3369607813924731") && !msgs_.containsKey(mid))
      {//check duplicates
        XML user = phrase.getChild("user");
        String screen_name = user.getChild("screen_name").getContent();

        boolean skip = false;
        if (no_vinjn)
        {
          for (String name : skip_names)
          {
            if (screen_name.equals(name))
            {
              skip = true;
              break;
            }
          }
        }

        if (skip)
          continue;

        String text = phrase.getChild("text").getContent(); 
        String profile_image_url = user.getChild("profile_image_url").getContent();
        list.add(new Phrase(mid, text, screen_name, profile_image_url));
      }
    }
    xmlLoading = false;
  }

  void run()
  {
    ArrayList<Phrase> list = new ArrayList<Phrase>();
    while (true)
    {
      if (millis() - mls > refresh_time_count)
      {
        mls = millis() ;
        println("运行线程:"+query_);
        parseXML(query_, list);
        //lock
        for (Phrase p : list)
        {
          String key = p.id+"";
          //          if (!msgs_.containsKey(key))
          {
            if (debug_feed)
              println(p.id+":"+p.profile_.name_);
            msgs_.put(key, p);
            dataChanged = true;
          }
        }
        //unlock
      }
      else
      {
        try {        
          sleep(1000);
        }
        catch (Exception e) {
        }
      }
    }
  }
}

