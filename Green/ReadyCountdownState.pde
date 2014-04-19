// TODO: fadeIn
// 3-2-1 countdown
class ReadyCountdownState extends State
{
  ReadyCountdownState()
  {
    super("ReadyCountdownState");
  }

  void enter()
  {
  }

  void draw()
  {
    image(greenBg, 0, 0, displayWidth, displayHeight);
    useShader();
    drawCamera();
    resetShader();
  }
}

