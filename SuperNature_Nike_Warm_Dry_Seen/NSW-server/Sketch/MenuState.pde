public class MenuState extends State {
    Movie mov;

    void enter() {
        if (true) {
            mov = getMovie("final1.mp4");
        } else {
            mov = getMovie("final_back+up.mp4");
        }
        mov.loop();
    }

    void quit() {
        stopMovie(mov);
    }

    void draw() {
        drawMovie(mov);
    }
}
