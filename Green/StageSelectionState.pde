// keying fade in
// 
PImage greenBg;
class StageSelectionState extends State
{
  final int kCountdownSec = 2;
  float mStartMS;

  StageSelectionState()
  {
    super("StageSelectionState");
  }

  void enter()
  {
    mStartMS = millis();
    greenBg = backImages.get((int)random(backImages.size()));
  }

  void draw()
  {
    if (millis() - mStartMS > kCountdownSec*1000)
    {
      changeState(new ReadyCountdownState());
      return;
    }

    if (frameCount % 2 == 0)
    {
      greenBg = backImages.get((int)random(backImages.size()));
    }

    image(greenBg, 0, 0, displayWidth, displayHeight);
  }
}

