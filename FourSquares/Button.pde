import de.looksgood.ani.*;

//Button has several vertices, intepolated from parent Region's VertexData
class Button
{
  String mName;
  int mPin;
  ArrayList<PVector> mVertices = new ArrayList<PVector>();
  color mButtonColor;

  Button(String name, int pin)
  {
    mName = name;
    mPin = pin;
  }

  String toString()
  {
    return mName + "/" + mPin;
  }

  void addVertex(PVector vertex)
  {
    if (mVertices.size() != 0)
    {
      interpolate(mVertices.get(mVertices.size() - 1), vertex);
    }
    mVertices.add(vertex);
  }

  void markEnd()
  {
    interpolate(mVertices.get(mVertices.size() - 1), mVertices.get(0));
  }

  int getPixelCount(PVector a, PVector b)
  {
    final int kMidDistance = 30;
    if ( a.dist(b) > kMidDistance)
    {
      return 30;
    }
    return 15;
  }

  void interpolate(PVector start, PVector end)
  {
    int count = getPixelCount(start, end);
    float step = 1.0f / count;
    for (int i=1;i<count;i++)
    {
      mVertices.add(PVector.lerp(start, end, i*step));
    }
  }

  float mRed, mGreen, mBlue;
  float mAlpha;

  void fadeOut()
  {
    Ani.to(this, kButtonFadeTime, "mAlpha", 0);
  }

  void fadeIn()
  {
    Ani.to(this, kButtonFadeTime, "mAlpha", 1.2);
  }

  void setColor(color clr)
  {
    mRed = red(clr);
    mGreen = green(clr);
    mBlue = blue(clr);
  }

  boolean isPressed = false;
  boolean isHit = false;

  // HACK
  void updateCenter()
  {
    for (PVector vertex: mVertices)
    {
      color clr = (color)vertex.z;
      float r = red(clr) * centerAlpha;
      float g = green(clr) * centerAlpha;
      float b = blue(clr) * centerAlpha;
      vertex.z = color((int)r, (int)g, (int)b);
    }
  }

  void update(Movie movie)
  {
    if (movie != null)
    {
      for (PVector vertex: mVertices)
      {
        vertex.z = movie.get((int)vertex.x, (int)vertex.y);
      }
    }
  }

  // TODO
  void updateArduino()
  {
    boolean high = isPinHigh(mPin);
    if (!isPressed && high)
    {
      isHit = true;
      fadeIn();
    }
    else
    {
      isHit = false;
    }

    if (!high)
    {
      fadeOut();
    }
    isPressed = high;
  }

  color getColor(PVector vertex)
  {
    color clr = (color)vertex.z;

    float r = blue(clr) * 0.6 + mRed*mAlpha;
    float g = green(clr) * 0.6 + mGreen*mAlpha;
    float b = red(clr) * 0.6 + mBlue*mAlpha;

    return color(r, g, b);
  }

  int draw1D(int x, int y)
  {
    for (PVector vertex: mVertices)
    {
      stroke(getColor(vertex));
      point(x, y);
      x++;
    }
    return x;
  }

  void draw2D(int x, int y)
  {
    for (PVector vertex: mVertices)
    {
      stroke(getColor(vertex));
      point(x + vertex.x, y + vertex.y);
    }

    drawArduino(x, y);
  }

  void drawArduino(float x, float y)
  {
    color high = color(255, 0, 0);
    color off = color(4, 79, 111);
    color on = color(84, 145, 158);
    int x0 = 730;
    stroke(on);

    if (isHit) 
    {
      fill(high);
      rect(x0 + 50, 20+mPin*20, 10, 10);
    }

    if (isPressed)
      fill(on);
    else
      fill(off);
    rect(x0 + 30, 20+mPin*20, 10, 10);
    fill(on);
    text("S"+mPin, x0+4, 10+20*(1+mPin));
  }
}

