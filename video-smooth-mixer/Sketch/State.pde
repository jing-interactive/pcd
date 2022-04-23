import controlP5.*;

void fillScreen(color clr) {
    fill(clr);
    noStroke();
    rect(0, 0, width, height);
}

public class State {
    float mStartMS;

    float elapsedSec() {
        return (millis() - mStartMS) * 0.001;
    }

    void enter() {
    }

    void quit() {
    }

    void draw() {
    }

    void mousePressed() {
    }

    void mouseDragged() {
    }

    void mouseReleased() {
    }

    void oscEvent(OscMessage msg) {

    }

    void fadeTo(String varName, float duration, float delay, float targetValue) {
        Ani.to(this, duration, delay, varName, targetValue, Ani.LINEAR);
    }

    void fadeInAlpha(String varName, float duration, float delay) {
        fadeTo(varName, duration, delay, 255);
    }

    void fadeInAlpha(String varName, float duration) {
        fadeInAlpha(varName, duration, 0);
    }

    void fadeOutAlpha(String varName, float duration, float delay) {
        fadeTo(varName, duration, delay, 0);
    }

    void fadeOutAlpha(String varName, float duration) {
        fadeOutAlpha(varName, duration, 0);
    }

    void applyAlpha(float alpha) {
        if (alpha < 254) {
            tint(255, alpha);
        }
    }

    float alphaEverything;
    void tryFadeOutEverything(float sec, float duration) {
        if (sec > duration - 3 && alphaEverything > 254) {
            println("sec: " + sec);
            alphaEverything = 254;
            fadeOutAlpha("alphaEverything", 3);
        }
        if (alphaEverything < 254) {
            fillScreen(color(0, 255 - alphaEverything));
        }
    }

    void defaultAlpha() {
        tint(255);
    }
}

State currentState;

private float lastFrameMilli = 0;
float deltaTimeSec = 0;
// call me from draw()
void drawState() {
    currentState.draw();

    deltaTimeSec = (millis() - lastFrameMilli) * 0.001;
    lastFrameMilli = millis();
}

String getStateName() {
    return currentState.getClass().getSimpleName(); // Java reflection is sweet :)
}

// call me when app needs to change its state
void changeState(State newState) {
    float startChangeMillis = millis();
    if (currentState != null) {
        println("- " + getStateName());
        currentState.quit();
        println("- cost " + (millis() - startChangeMillis) + " ms");
        // System.gc();
    }
    currentState = newState;
    println("+ " + getStateName());
    currentState.alphaEverything = 255;
    currentState.enter();
    currentState.mStartMS = millis();
    println("Total cost " + (currentState.mStartMS - startChangeMillis) + " ms");
    lastFrameMilli = millis();
}

