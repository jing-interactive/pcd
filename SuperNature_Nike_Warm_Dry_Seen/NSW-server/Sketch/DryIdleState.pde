public class DryIdleState extends State {
    Movie mov;

    void enter() {
        mov = getMovie("dry.mp4");
        mov.loop();
    }

    void quit() {
        stopMovie(mov);
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/dry/v")) {
            newState = new DryState();
        }
    }

    void draw() {
        tint(200, 200, 255);
        // tint(CFG_WARM_R, CFG_WARM_G, CFG_WARM_B, CFG_WARM_A);
        drawMovie(mov);
    }
}
