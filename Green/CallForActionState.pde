class CallForActionState extends State
{
  float mStartMS;
  final int kCountdownSec = 10;
  
  float mAlpha = 255;
  final float kMinAlpha = 50;
  final float kDarkenSec = 3;
  
  CallForActionState()
  {
    super("CallForActionState");
  }

  void enter()
  {
    mStartMS = millis();
    Ani.to(this, kDarkenSec, "mAlpha", kMinAlpha);
  }

  void draw()
  {
    if (millis() - mStartMS > kCountdownSec*1000)
    {
      changeState(new StageSelectionState());
      return;
    }
    tint(mAlpha);
    drawCamera();
    color(255);
    text("CALL FOR ACTION. [PLACEHOLDER]", 300, 400);
  }
}

