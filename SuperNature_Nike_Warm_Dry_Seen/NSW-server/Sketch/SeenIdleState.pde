
class Star {
    float x, y;
    float alpha;
    boolean alive = false;

    void shoot() {
        alive = true;
        x = random(width);
        y = random(height);
        alpha = 0;
        Ani.to(this, random(0.1, 2),
               0, "alpha", 512, Ani.LINEAR);
    }

    void draw() {
        if (alive) {
            float a = alpha;
            if (a > 256) {
                a = 512 - a;
            }
            fill(255, a);
            final float r = 20;
            ellipse(x, y, r, r);

            if (alpha == 512) {
                // println("alpha: " + alpha);
                alive = false;
            }
        }
    }
};

Star[] stars;

public class SeenIdleState extends State {
    Movie mov;

    void enter() {
        mov = getMovie("seen.mp4");
        mov.play();
        isIdle = true;

        if (stars == null) {
            stars = new Star[200];
            for (int i = 0; i < stars.length; i++) {
                stars[i] = new Star();
            }
        }
    }

    void quit() {
        // stopMovie(mov);
    }

    void oscEvent(OscMessage msg) {
        if (msg.checkAddrPattern("/seen/v")) {
            newState = new SeenState();
        }
    }

    void draw() {
        background(0);
        // fillScreen(color(0, renderAlpha * 0.13));
        // tint(CFG_WARM_R, CFG_WARM_G, CFG_WARM_B, CFG_WARM_A);
        // float alpha = abs(sin(elapsedSec())) * 255;
        // fillScreen(color(122, alpha));
        for (Star o : stars) {
            if (!o.alive) {
                o.shoot();
            }
        }
        for (Star o : stars) {
            o.draw();
        }
    }
}
