#pragma once

#define millis() ofGetSystemTime()
#define random(a,b) ofRandom(a,b)
#define color ofColor
#define strokeWeight(w) ofSetLineWidth(w)
#define stroke(clr) ofSetColor(clr)
#define rect(a,b,c,d) ofRect(a,b,c,d)
#define vertex(x,y) ofVertex(x,y)
#define frameCount ofGetFrameNum()
#define String std::string
#define background(r,g,b) ofBackground(r,g,b)
#define LINES
#define beginShape(a) ofBeginShape()
#define endShape(b) ofEndShape(b)
#define final const
#define boolean bool

#undef class
#define class struct

#define println(str) printf("%s\n", str)


inline float sq(float n){return n*n;}