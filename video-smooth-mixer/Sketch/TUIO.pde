import TUIO.*;

TuioProcessing tuioClient;

void setupTuio() {
	tuioClient  = new TuioProcessing(this, TUIO_LOCAL_PORT);
}

final int FAKE_BLOB_ID = 9999;

void addTuioCursor(TuioCursor tcur) {
	println("add cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ") " + tcur.getX() + " " + tcur.getY());
}

void updateTuioCursor (TuioCursor tcur) {
	println("set cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ") " + tcur.getX() + " " + tcur.getY()
	        + " " + tcur.getMotionSpeed() + " " + tcur.getMotionAccel());
}

void removeTuioCursor(TuioCursor tcur) {
	println("del cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ")");
}

// The following callbacks are not so important, uncomment them if they are necessary.
/*

void addTuioObject(TuioObject tobj) {
  println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

void updateTuioObject (TuioObject tobj) {
  println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

void removeTuioObject(TuioObject tobj) {
  println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

void addTuioBlob(TuioBlob tblb) {
  println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
}

void updateTuioBlob (TuioBlob tblb) {
  println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
}

void removeTuioBlob(TuioBlob tblb) {
  println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
}

// marks the end of each TUIO frame
void refresh(TuioTime frameTime) {
  println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
}

*/