class State
{
  String mName;
  State(String name)
  {
    mName = name;
  }
  void enter() 
  {
  }

  void exit() 
  {
  }

  void draw() 
  {
  }
}

State mState = null;
void drawState()
{
  mState.draw();
}

void changeState(State newState)
{
  if (mState != null)
  {
    println("- " + mState.mName);
    mState.exit();
  }
  mState = newState;
  println("+ " + mState.mName);
  mState.enter();
}

