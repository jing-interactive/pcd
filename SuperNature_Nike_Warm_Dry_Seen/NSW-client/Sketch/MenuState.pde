
public class MenuState extends State {
    float alpha;
    int exitCounter = 0;
    PImage btn;

    void enter() {
        movMenu = getMovie("screensaver.mp4");
        movMenu.loop();
        btn = getImage("word_dry.png");

        sendOsc("/state", "menu");
        alpha = 0;
        fadeInAlpha("alpha", MENU_FADEIN_SECONDS);
    }

    void quit() {
        // stopMovie(movMenu);
    }

    void draw() {
        applyAlpha(alpha);
        drawMovie(movMenu);
        image(getImage("snakerboots.png"), toX(LOGO_X), toY(LOGO_Y));

        image(getImage("word_dry.png"), toX(DRY_MENU_X), toY(DRY_MENU_Y), toX(btn.width), toY(btn.height));
        image(getImage("word_warm.png"), toX(WARM_MENU_X), toY(WARM_MENU_Y), toX(btn.width), toY(btn.height));
        image(getImage("word_seen.png"), toX(SEEN_MENU_X), toY(SEEN_MENU_Y), toX(btn.width), toY(btn.height));

        if (false) {
            stroke(255, 0, 0);
            ellipse(toX(SEEN_MENU_X), toY(SEEN_MENU_Y), toX(MENU_BUTTON_RADIUS), toX(MENU_BUTTON_RADIUS));
            ellipse(toX(WARM_MENU_X), toY(WARM_MENU_Y), toX(MENU_BUTTON_RADIUS), toX(MENU_BUTTON_RADIUS));
            ellipse(toX(DRY_MENU_X), toY(DRY_MENU_Y), toX(MENU_BUTTON_RADIUS), toX(MENU_BUTTON_RADIUS));
        }
    }

    void mouseReleased() {
        if (overRect2(SEEN_MENU_X, SEEN_MENU_Y, btn.width, btn.height)) {
            changeState(new TransitionState(new SeenState()));
        } else if (overRect2(WARM_MENU_X, WARM_MENU_Y, btn.width, btn.height)) {
            changeState(new TransitionState(new WarmState()));
        } else if (overRect2(DRY_MENU_X, DRY_MENU_Y, btn.width, btn.height)) {
            changeState(new TransitionState(new DryState()));
        }

        if (mouseX < width / 4 && mouseY < height / 4 &&  exitCounter++ > 10) {
            sendOsc("/state", "black");
            exit();
        }
    }

    Movie movMenu;
}
