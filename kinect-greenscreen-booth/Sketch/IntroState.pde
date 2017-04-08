public class IntroState extends State {
    void enter() {
    }

    void quit() {
    }

    void draw() {
        if (mousePressed && mouseButton == RIGHT) {
            changeState(new PlayState());
        }

        if (kinectDevice.isTracked()) {
            changeState(new PlayState());
        }

        drawKinect();
    }
}
