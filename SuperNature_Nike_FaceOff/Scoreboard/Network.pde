import oscP5.*;
import netP5.*;
import processing.net.*;

String[] people_list = new String[10];
String[] team_list = new String[2];

int[] speed_list = new int[10];
int[] miles_list = new int[10];

String login_server = "127.0.0.1";

OscP5 oscP5;
NetAddress myRemoteLocation;
TcpServer runner;
Server s;

void network_setup()
{
  oscP5 = new OscP5(this, 3333);
  myRemoteLocation = new NetAddress(login_server, 3334);
  //  runner = new TcpServer(this, 4000);
  s = new Server(this, 4000);
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
          if (debug)
            println(value_list[i]);
        }
        catch(UnsupportedEncodingException e) {
          e.printStackTrace();
        }
      }
    }//end double if
}
