/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
String remoteIP = "127.0.0.1";
int remotePort = 7001;

void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 7000);
}

void draw() {
  background(0);
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage;

  if (mouseButton == LEFT)
    myMessage = new OscMessage("/deactivate");
  else
    myMessage = new OscMessage("/activate");

  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, remoteIP, remotePort); 

  println(">>> osc sent to "+remoteIP+":"+remotePort);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage m) {
  remoteIP = m.netAddress().address();
  /* print the address pattern and the typetag of the received OscMessage */
  print("### "+m.addrPattern()+" from "+remoteIP);
  println(" typetag: "+m.typetag());
}

