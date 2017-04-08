/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOsc() {
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, 7000);

    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
     * an ip address and a port number. myRemoteLocation is used as parameter in
     * oscP5.send() when sending osc packets to another computer, device,
     * application. usage see below. for testing purposes the listening port
     * and the port of the remote location address are the same, hence you will
     * send messages back to this sketch.
     */
    myRemoteLocation = new NetAddress("127.0.0.1", 8000);
}

private void testOsc() {
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage msg = new OscMessage("/test");

    msg.add(123); /* add an int to the osc message */

    /* send the message */
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name) {
    OscMessage msg = new OscMessage(name);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, String value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, float value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, int value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
    /* print the address pattern and the typetag of the received OscMessage */
    if (VERBOSE_MODE) {
        print("### received an osc message.");
        print(" addrpattern: " + msg.addrPattern());
        println(" typetag: " + msg.typetag());
    }

    if (msg.checkAddrPattern("/state")) {
        String state = msg.get(0).stringValue();
        if (state.equals("menu")) {
            newState = new MenuState();
        } else if (state.equals("warm")) {
            newState = new WarmState();
        } else if (state.equals("dry")) {
            newState = new DryState();
        } else if (state.equals("seen")) {
            newState = new SeenState();
        } else if (state.equals("black")) {
            newState = new BlackState();
        }
    }

    currentState.oscEvent(msg);
}
