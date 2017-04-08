class KinectDevice {
    PImage getRgbImage() { return null; }
    PVector getRightHand() { return null; }
    void update() {}
    boolean isTracked() { return false;}
}

import KinectPV2.*;
import KinectPV2.KJoint;

class KinectV2 extends KinectDevice {
    KinectPV2 kinect;
    Skeleton [] skeleton;
    int playerIdx = -1;

    KinectV2() {
        kinect = new KinectPV2(self);
        kinect.enableColorImg(true);
        kinect.enableSkeletonColorMap(true);
        kinect.init();
    }

    PImage getRgbImage() {
        return kinect.getColorImage();
    }

    void update() {
        skeleton =  kinect.getSkeletonColorMap();

        playerIdx = -1;
        // TODO: track the first player
        for (int i = 0; i < skeleton.length; i++) {
            if (skeleton[i].isTracked()) {
                playerIdx = i;
                break;
            }
        }
    }

    boolean isTracked() {
        return playerIdx != -1;
    }

    PVector getRightHand() {
        KJoint[] joints = skeleton[playerIdx].getJoints();
        KJoint handR = joints[KinectPV2.JointType_HandRight];
        return new PVector(handR.getX(), handR.getY(), 0.0f);
    }

    void drawBone(KJoint[] joints, int jointType1, int jointType2) {
        pushMatrix();
        translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
        ellipse(0, 0, 25, 25);
        popMatrix();
        line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
    }
}

class KinectFake extends KinectDevice {
    KinectFake() {

    }

    PImage getRgbImage() {
        return getImage("KinectSnapshot-10-33-12.jpg");
    }

    PVector getRightHand() {
        return new PVector(mouseX, mouseY);
    }

    boolean isTracked() {
        return true;
    }
}

KinectDevice kinectDevice;

void setupKinect() {
    if (loadStrings("fake.txt") != null) {
        kinectDevice = new KinectFake();
    } else {
        kinectDevice = new KinectV2();
    }
}

void updateKinect() {
    kinectDevice.update();

    if (kinectDevice.isTracked()) {
        lastMouseMillis = millis();
    }
}

void drawKinect() {
    image(kinectDevice.getRgbImage());
}
