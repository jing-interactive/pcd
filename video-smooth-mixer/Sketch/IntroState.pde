public class IntroState extends State {
    void enter() {
    }

    void quit() {
    }

    void draw() {
        ellipse(noise(millis * 0.001) * width, noise(millis * 0.002) * height, 20, 20);
        if (isMouseDown) {
            changeState(new MenuState());
        }
    }
}
