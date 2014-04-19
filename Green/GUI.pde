import controlP5.*;

ControlP5 cp5;

float sliderY = 100;
void addValue(String name, float maxValue)
{
  cp5.addSlider(name)
    .setPosition(100, sliderY += 30)
      .setRange(0, maxValue)
        ;
}

void setupGUI()
{
  cp5 = new ControlP5(this);

  addValue("keyingR", 255);
  addValue("keyingG", 255);
  addValue("keyingB", 255);

  addValue("thresh", 1.732);
  addValue("slope", 1);
}

