//Button has several vertices, intepolated from parent Region's VertexData
class Button
{
    String mName;
    ArrayList<PVector> mVertices = new ArrayList<PVector>();

    Button(String name)
    {
        mName = name;
    }

    String toString()
    {
        return mName + "/" + mVertices.size();
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
            println(a + "->" + b);
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

    void draw()
    {
        for (PVector vertex: mVertices)
        {
            fill((int)vertex.z);
            ellipse(vertex.x, vertex.y, 10, 10);
        }
    }
}

