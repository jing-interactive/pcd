

class ConfigState extends State {
  void enter() {
    SHOW_GUI = true;
  }

  void quit() {
    SHOW_GUI = false;
  }

  float toX(float x) {
    return x * width / kCamWidth;
  }

  float toY(float y) {
    return y * height / kCamHeight;
  }

  void draw() {
    background(0);
    useShader();
    // drawCamera(false);
    resetShader();

    y2 = x2 * height / width;

    pushStyle();
    final float radius = 20;
    fill(255, 0, 0);
    ellipse(toX(x1), height - toY(y1 + y2), radius, radius);
    ellipse(toX(x1 + x2), height - toY(y1), radius, radius);
    noFill();
    stroke(255, 0, 0);
    rect(toX(x1), height - toY(y1 + y2), toX(x2), toY(y2));
    popStyle();
  }
}

