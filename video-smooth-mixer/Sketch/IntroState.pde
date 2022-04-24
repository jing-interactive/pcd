Movie mov;

public class IntroState extends State {
    void enter() {
      mov = getMovie("A.mp4");
      mov.loop();
    }

    void quit() {
    }

    void draw() {
        drawMovie(mov);
        //ellipse(noise(millis * 0.001) * width, noise(millis * 0.002) * height, 20, 20);
        //if (isMouseDown) {
        //    changeState(new MenuState());
        //}
    }
}
