
float millis; // The value of millis() at the beginning of draw()
PImage prevSnapshot;
float renderAlpha = 255;
State newState;

void setup() {
    size(440, 280, P2D);
    frame.setLocation(-2, -24);

    setupGUI();
    setupOsc();

    Ani.init(this);
    Ani.noOverwrite();

    background(0);
    prevSnapshot = get();

    changeState(new MenuState());

    noStroke();
}

boolean isIdle = false;
final float kTransitionSeconds = 0.5;

void fadeTo(String varName, float duration, float targetValue) {
    Ani.to(this, duration, 0, varName, targetValue, Ani.LINEAR);
}

void draw() {
    millis = millis();

    float alpha = 0;
    if (renderAlpha < 255) {
        tint(255, 255 - renderAlpha);
        image(prevSnapshot);
        tint(255, renderAlpha);
    }
    drawState();
    tint(255);
    if (newState != null) {
        prevSnapshot = get();
        changeState(newState);
        renderAlpha = 0;
        fadeTo("renderAlpha", kTransitionSeconds, 255);
        newState = null;
    }
    drawGUI();
}

void drawGUI() {
    if (SHOW_GUI) {
        grpConfig.show();
        // textFont(sysFont);
        textAlign(LEFT, BASELINE);

        fill(255);
        stroke(255);
        text("State: " + getStateName() + "\n" +
             "=g= GUI\n" +
             "=m= Menu\n" +
             "=i= Intro\n" +
             "\n" +
             "fps: " + int(frameRate), width - 200, 50);
    } else {
        grpConfig.hide();
    }
    cp5.draw();
}

void keyReleased() {
    if (key == 'm') newState = new MenuState();
    else if (key == 'w') newState = new WarmState();
    else if (key == 'd') newState = new DryState();
    else if (key == 's') newState = new SeenState();

    if (key == 'g') SHOW_GUI = !SHOW_GUI;
}

void mouseReleased() {
    currentState.mouseReleased();
}
