
float lastMouseMillis;
float millis; // The value of millis() at the beginning of draw()

PImage homeButton, helpButton, helpButtonOff;
PApplet self;
PVector triangleCenter;

void setup() {
    // make sure it fit every screen
    // w / h = ww / hh;
    // w = ww * h / hh;
    self = this;
    println("millis(): " + millis());
    int height = displayHeight;
    int width = int(TARGET_WIDTH * height / TARGET_HEIGHT);
    println("width: " + width);
    println("height: " + height);
    size(width, height, P2D);
    noCursor();

    if (displayWidth == TARGET_WIDTH) {
        SHOW_GUI = false;
    }
    // smooth(8);

    for (int i = 0; i < 3; i++) {
        outerX[i] = toX(outerX[i]);
        outerY[i] = toY(outerY[i]);
        innerX[i] = toX(innerX[i]);
        innerY[i] = toY(innerY[i]);
    }

    // triangleCenter = new PVector(toX(innerX[0]), toY(innerY[0]));
    triangleCenter = new PVector(width / 2, height / 2);

    Ani.init(this);
    // Ani.noOverwrite();
    println("millis(): " + millis());

    setupOsc();
    println("millis(): " + millis());

    setupGUI();

    getMovie("WarmHelp.mp4");
    getMovie("SeenHelp.mp4");
    getMovie("DryHelp.mp4");

    homeButton = getImage("_0003_back_out.png");//, "_0005_back_in.png");
    // homeButton.setPosition(toX(BACK_X), toY(BACK_Y)).hide();
    helpButton = getImage("_0002___out.png");//, "_0004___in.png");
    helpButtonOff = getImage("_0004___in.png");
    // helpButton.setPosition(toX(HELP_X), toY(HELP_Y)).hide();
    println("millis(): " + millis());

    changeState(new MenuState());
    println("millis(): " + millis());

    lastMouseMillis = millis();
}

void draw() {

    mousePos.set(mouseX, mouseY);

    millis = millis();

    CFG_SWITCH_MENU_SECONDS = 12;
    if (millis - lastMouseMillis > CFG_SWITCH_MENU_SECONDS * 1000) {
        lastMouseMillis = millis;
        if (!getStateName().equals("MenuState") ) {
            changeState(new MenuState());
        }
    }
    if (!getStateName().equals("MenuState") ) {
        background(36, 32, 33);
    }

    drawState();
    image(getImage("_0001_url.png"), toX(URL_X), toY(URL_Y));

    drawGUI();
}

void drawGUI() {
    if (SHOW_GUI) {
        cursor();
        grpConfig.show();
        // textFont(sysFont);
        textAlign(LEFT, BASELINE);

        fill(255);
        stroke(255);
        text("State: " + getStateName() + "\n" +
             "=g= GUI\n" +
             "=m= Menu\n" +
             "=s= Seen\n" +
             "=w= Warm\n" +
             "=d= Dry\n" +
             "\n" +
             "fps: " + int(frameRate), width - 200, 50);
    } else {
        noCursor();
        grpConfig.hide();
    }
    cp5.draw();
}

void keyReleased() {
    if (key == 'm') changeState(new MenuState());
    else if (key == 's') changeState(new TransitionState(new SeenState()));
    else if (key == 'w') changeState(new TransitionState(new WarmState()));
    else if (key == 'd') changeState(new TransitionState(new DryState()));

    if (key == 'g') SHOW_GUI = !SHOW_GUI;
}

PVector mouseStart = new PVector();
PVector mouseDragged = new PVector();
PVector mousePos = new PVector();
boolean isMouseDown = false;
boolean mouseReleased = false;

void mousePressed() {
    mouseReleased = false;
    isMouseDown = true;
    mouseStart.set(mouseX, mouseY);
    lastMouseMillis = millis;

    currentState.mousePressed();
    if (isHelpVisble) {
        toShowHelp = false;
    } else {
        if (!isFadingOut && overRect2(HOME_X, HOME_Y, homeButton.width, homeButton.height)) {
            isFadingOut = true;
            Ani.to(this, INTERACTOIN_FADEOUT_SECONDS, 0, "interactionAlpha", 0);
            // changeState(new MenuState());
        } else if (overRect2(HELP_X, HELP_Y, helpButton.width, helpButton.height)) {
            toShowHelp = true;
        }
    }
}

void mouseDragged() {
    mouseDragged.set(mouseX - mouseStart.x, mouseY - mouseStart.y);
    lastMouseMillis = millis;

    currentState.mouseDragged();
}

void mouseReleased() {
    lastMouseMillis = millis;

    mouseReleased = true;
    isMouseDown = false;
    mouseDragged.set(0, 0);
    currentState.mouseReleased();

}

float toX(float x) {
    return x / PSD_WIDTH * width;
}

float toY(float y) {
    return y / PSD_HEIGHT * height;
}

boolean isFadingOut = false;
boolean isHelpVisble = false;
boolean toShowHelp = false;
void interactiveCommon(PImage title, Movie movHelp, PImage tips,
                       PImage pop, PImage popColor) {
    currentState.applyAlpha(interactionAlpha);

    image(title, toX(TITLE_X), toY(TITLE_Y));

    int stateIndex = 0;
    boolean isSeen = getStateName().equals("SeenState");
    if (isSeen) {
        stateIndex = 2;
    } else {
        if (getStateName().equals("WarmState")) stateIndex = 0;
        else stateIndex = 1;
    }

    CFG_SWITCH_IDLE_SECONDS = 5;
    if (millis - lastMouseMillis > CFG_SWITCH_IDLE_SECONDS * 1000) {
        // lastMouseMillis = millis;
        sendOsc("/idle");
    }
    image(tips, toX(tipsX[stateIndex]), toY(tipsY[stateIndex]));
    image(homeButton, toX(HOME_X), toY(HOME_Y), toX(homeButton.width), toY(homeButton.height));
    image(pop, toX(popX[stateIndex * 2]), toY(popY[stateIndex * 2]), toX(pop.width), toY(pop.height));

    if (isHelpVisble) {
        lastMouseMillis = millis;

        image(helpButtonOff, toX(HELP_X), toY(HELP_Y), toX(helpButton.width), toY(helpButton.height));

        blendMode(ADD);
        // drawMovie(movHelp);
        if (movHelp.available()) {
            movHelp.read();
        }
        if (movHelp.time() > 0.01) {
            image(movHelp, 0, isSeen ? toY(581) : 0, width, isSeen ? toY(movHelp.height) : height);
        }

        blendMode(BLEND);

        if (!toShowHelp) {
            stopMovie(movHelp);
            isHelpVisble = false;
        }
    } else {
        // image(homeButton, toX(HOME_X), toY(HOME_Y), toX(homeButton.width), toY(homeButton.height));
        image(helpButton, toX(HELP_X), toY(HELP_Y), toX(helpButton.width), toY(helpButton.height));

        if (toShowHelp) {
            isHelpVisble = true;
            movHelp.loop();
        }
    }

    currentState.applyAlpha(abs(sin(currentState.elapsedSec() * 0.4 * PI)) * interactionAlpha);
    image(popColor, toX(popX[stateIndex * 2 + 1]), toY(popY[stateIndex * 2 + 1]), toX(popColor.width), toY(popColor.height));

    currentState.defaultAlpha();

    if (isFadingOut) {
        // println("interactionAlpha: " + interactionAlpha);
        // fillScreen(color(0, 255 - interactionAlpha));
        if (interactionAlpha < 1) {
            changeState(new MenuState());
        }
    } else {
        if (interactionAlpha == 0) {
            interactionAlpha = 1;
            Ani.to(this, INTERACTOIN_FADEIN_SECONDS, 0, "interactionAlpha", 255, Ani.LINEAR);
        }
        if (interactionAlpha < 254) {
            Movie movTransit = getMovie("transition.mp4");
            // println("interactionAlpha: " + interactionAlpha);
            // fillScreen(color(0, 255 - interactionAlpha));
            if (movTransit.time() < movTransit.duration() - 0.05) {
                blendMode(ADD);
                drawMovie(movTransit, toX(TRANS_X), toY(TRANS_Y), toX(movTransit.width * 2), toY(movTransit.height * 2));
                blendMode(BLEND);
            }
        }
    }
}
