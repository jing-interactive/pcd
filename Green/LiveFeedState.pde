class LiveFeedState extends State
{
  LiveFeedState()
  {
    super("LiveFeedState");
  }
  
  void draw()
  {
    drawCamera();
    image(intro, 0, 0, displayWidth, displayHeight);
    
    if (keyPressed)
    {
      changeState(new CallForActionState());
    }
  }
}
