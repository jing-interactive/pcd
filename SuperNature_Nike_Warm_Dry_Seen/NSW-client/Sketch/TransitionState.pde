float interactionAlpha = 0;

public class TransitionState extends State {
    float alpha = 255;
    State mNextState;
    PImage glow;
    PImage btn;

    TransitionState(State nextState) {
        mNextState = nextState;
    }

    void enter() {
        btn = getImage("word_dry.png");
        glow = getImage("glow.png");
        movMenu = getMovie("screensaver.mp4");
        movTransit = getMovie("transition.mp4");
        stopMovie(movTransit);

        fadeOutAlpha("alpha", MENU_FADEOUT_SECONDS);
    }

    void quit() {
        stopMovie(movMenu);
        lastMouseMillis = millis;

        interactionAlpha = 0;
        defaultAlpha();
        isFadingOut = false;

        isHelpVisble = false;
        toShowHelp = true;
        // stopMovie(movTransit);
    }

    void draw() {
        // println("alpha: " + alpha);
        applyAlpha(alpha);
        drawMovie(movMenu);
        image(getImage("snakerboots.png"), LOGO_X, LOGO_Y);
        image(getImage("word_dry.png"), toX(DRY_MENU_X), toY(DRY_MENU_Y), toX(btn.width), toY(btn.height));
        image(getImage("word_warm.png"), toX(WARM_MENU_X), toY(WARM_MENU_Y), toX(btn.width), toY(btn.height));
        image(getImage("word_seen.png"), toX(SEEN_MENU_X), toY(SEEN_MENU_Y), toX(btn.width), toY(btn.height));

        // blendMode(ADD);
        // applyAlpha(255 - alpha);
        // drawMovie(movTransit, toX(TRANS_X), toY(TRANS_Y), toX(movTransit.width * 2), toY(movTransit.height * 2));
        // blendMode(BLEND);

        if (alpha == 0) {
            movTransit.play();
            changeState(mNextState);
        }

        if (alpha > 0) {
            applyAlpha(alpha < 122 ? alpha * 2 : 255 * 2 - alpha * 2);
            String nextStateName = mNextState.getClass().getSimpleName();
            if (nextStateName.equals("SeenState")) {
                image(glow, toX(SEEN_MENU2_X), toY(SEEN_MENU2_Y), toX(glow.width), toY(glow.height));
            } else if (nextStateName.equals("WarmState")) {
                image(glow, toX(WARM_MENU2_X), toY(WARM_MENU2_Y), toX(glow.width), toY(glow.height));
            } else if (nextStateName.equals("DryState")) {
                image(glow, toX(DRY_MENU2_X), toY(DRY_MENU2_Y), toX(glow.width), toY(glow.height));
            }
        }
        defaultAlpha();
    }

    Movie movMenu;
    Movie movTransit;
}
