import oscP5.*;
import netP5.*;

import processing.net.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
TcpServer runner;
Server s;

boolean team_mode = false;
String[] people_list = new String[10];
String[] team_list = new String[2];

String login_server = "127.0.0.1";

//team_A [0..5]
//team_B [6..11]
//team_A_name [12]
//team_B_name [13]

void setup() {
  size(400, 800); 
  oscP5 = new OscP5(this, 3333);
  myRemoteLocation = new NetAddress(login_server, 3334);
  //  runner = new TcpServer(this, 4000);
  s = new Server(this, 4000);
  PFont font = createFont("宋体", 24);
  textFont(font);
}

void netEvent(NetMessage msg)
{
  println(msg.getString());
}

void draw() {
  background(0);
  
  if (keyPressed)
  {
   s.write("s\n");//end
  }
  
  if (mousePressed)
  {
   s.write("e\n");//end
  }  

  Client c = s.available();
  if (c != null) {
    String input = c.readString();
    println(input);
  }
  
  if (team_mode)
  {
  }
  for (int i=0;i<6;i++)
  {
    /*
    int y0 = 200;
     if (name_list[i] != null)
     text(name_list[i], 50, y0+ i * 40);
     if (name_list[i+6] != null)
     text(name_list[i+6], 250, y0+ i * 40);
     */
  }
}

void oscEvent(OscMessage msg) 
{
  String patt = msg.addrPattern();
  println(patt);
  //println(msg.netAddress());
  if (patt.equals("/team") || patt.equals("/people"))
  {
    oscP5.send(msg, myRemoteLocation);
  }
  else
    if (patt.equals("/team_CN") || patt.equals("/people_CN"))
    {
      int n_list = 0;
      String[] value_list = null;
      if (patt.equals("/team_CN"))
      {
        team_mode = true;
        value_list = team_list;
        n_list = 2;//for team_A_name && team_B_name
      }
      else
      {
        team_mode = false;      
        value_list = people_list;
        n_list = 10;
      }

      int next = 0;
      for (int i=0;i<n_list;i++)
      { 
        int strlen = msg.get(next).intValue();
        byte[] bts = new byte[strlen];
        for (int k=0;k<strlen;k++)
        {
          int c = msg.get(next+1+k).intValue();
          bts[k] = (byte)c;
        }
        next += (strlen+1);

        try {
          if (strlen > 0)
            value_list[i] = new String(bts, "GBK");
          else
            value_list[i] = null;//表示没有参赛者
          println(value_list[i]);
        }
        catch(Exception e) {
          e.printStackTrace();
        }
      }
    }//end double if
}

