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
//            println(a + "->" + b);
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

    boolean isPressed = false;

    void update(Movie movie)
    {
        if (movie != null)
        {
            for (PVector vertex: mVertices)
            {
                vertex.z = movie.get((int)vertex.x, (int)vertex.y);
            }
        }
        isPressed = pinStatus[mPin];
    }

    void update()
    {
        isPressed = isPinHigh(mPin);
    }

    color getColor(PVector vertex)
    {
        return (int)vertex.z + mButtonColor;
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
    }
}

