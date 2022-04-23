
float lastMouseMillis;
float millis; // The value of millis() at the beginning of draw()

void setup() {
    size(displayWidth, displayHeight, P2D);
    setupGUI();
    // setupOsc();
    // setupTuio();
    setupAudio();

    Ani.init(this);
    Ani.noOverwrite(); 

    changeState(new IntroState());

    lastMouseMillis = millis();
}

void draw() {
    millis = millis();
    background(122);

    if (millis - lastMouseMillis > CFG_SWITCH_INTRO_SECONDS * 1000) {
        if (!getStateName().equals("IntroState") ) {
            changeState(new IntroState());
        }
    }
    drawState();

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
    if (key == 'm') changeState(new MenuState());
    else if (key == 'i') changeState(new IntroState());

    if (key == 'g') SHOW_GUI = !SHOW_GUI;
}

boolean isMouseDown = false;

PVector mouseStart = new PVector();
PVector mouseDragged = new PVector();

void mousePressed() {
    lastMouseMillis = millis;
    isMouseDown = true;

    mouseStart.set(mouseX, mouseY);

    currentState.mousePressed();
}

void mouseDragged() {
    lastMouseMillis = millis;
    mouseDragged.set(mouseX - mouseStart.x, mouseY - mouseStart.y);

    currentState.mouseDragged();
}

void mouseReleased() {
    isMouseDown = false;
    lastMouseMillis = millis;
    mouseDragged.set(0, 0);
    currentState.mouseReleased();
}