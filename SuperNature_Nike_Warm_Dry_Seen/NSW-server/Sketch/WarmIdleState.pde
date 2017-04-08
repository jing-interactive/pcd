
public class WarmIdleState extends State {
    PImage palette;

    void enter() {
        palette = getImage("WarmPalette.png");
    }

    void quit() {
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/warm/v")) {
            newState = new WarmState();
        }
    }

    void draw() {
        if (true) {
            fillScreen(color(0, renderAlpha));
            // tint(CFG_WARM_R, CFG_WARM_G, CFG_WARM_B, CFG_WARM_A);
            float alpha = abs(sin(1.65 + elapsedSec() * 0.7)) * 1;

            textureMode(NORMAL);
            textureWrap(REPEAT);

            applyAlpha((0.5 + alpha * 0.5) * 255);

            final float k = 0.5;
            beginShape();
            texture(palette);
            vertex(0, 0, warmValue, 0);
            vertex(width, 0, warmValue + k, 0);
            vertex(width, height, warmValue + k, 1);
            vertex(0, height, warmValue, 1);
            endShape(CLOSE);
        } else {
            float alpha = abs(sin(elapsedSec() * 0.7)) * 1;

            textureMode(NORMAL);
            textureWrap(REPEAT);

            final float k = 0.5;
            beginShape();
            texture(palette);
            vertex(0, 0, warmValue + alpha, 0);
            vertex(width, 0, warmValue + k + alpha, 0);
            vertex(width, height, warmValue + k + alpha, 1);
            vertex(0, height, warmValue + alpha, 1);
            endShape(CLOSE);
        }
    }
}