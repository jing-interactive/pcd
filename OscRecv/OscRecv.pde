/**
 * oscP5parsing by andreas schlegel
 * example shows how to parse incoming osc messages "by hand".
 * it is recommended to take a look at oscP5plug for an
 * alternative and more convenient way to parse messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
String info = "";

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,7000);   
}

void draw() {
  background(0); 
  text(info, 10,height/2);
}
 
void oscEvent(OscMessage m) {
  /* check if theOscMessage has the address pattern we are looking for. */
  info = "### received "+m.addrPattern();
  println(info);
}
