final color[] ballColors = {
    color(74, 132, 150), // red
    color(111, 30, 30), // coffee
    color(153, 153, 153), // yellow
    color(14, 160, 0), // green
    color(42, 125, 89), // blue
    color(181, 137, 21), // purple
    color(20, 20, 20), // black
};

final int kSpacing = 20;
final int kCellCount = 9;
final int kBallRadius = 40;
final int kCellSize = int(kBallRadius*1.4f);
final int kBoardSize = kCellSize * kCellCount;
final int kNewBallCount = 3;
final int kMinMatchBallCount = 5;

int emptyCellCount;
int score;

int Width = 600;
int Height = 600;

final int kEmptyCell = -1;
final int kInvalidIndex = -11;

int[][] cells = new int[kCellCount][kCellCount];
int[] newBallIndices = new int[kNewBallCount];
int[] newBallCol = new int[kNewBallCount];
int[] newBallRow = new int[kNewBallCount];
int currentCol, currentRow;
int targetCol, targetRow;
boolean srcSelected = false;
boolean destSelected = false;

boolean readyForNewBalls = false;
Pathfinder pathfinder = new Pathfinder(kCellCount, kCellCount, 1, 1);

void setup()
{
    size(Width, Height);
    frameRate(30);
    for (int col=0; col<kCellCount; col++) 
    {
        for (int row=0; row<kCellCount; row++) 
        {
            cells[row][col] = kEmptyCell;
        }
    }
    currentCol = currentRow = kInvalidIndex;
    targetCol = targetRow = kInvalidIndex;
    emptyCellCount = kCellCount * kCellCount;
    
    generateNewBalls(true);
}

int mouseToCell(float mouseXY)
{
    float c = (mouseXY - kSpacing)/kCellSize;
    if (c >= 0 && c < kCellCount)
        return int(c);
    else
        return kInvalidIndex;
}

float cellToDraw(float cellXY)
{
    return cellXY*kCellSize + kSpacing;
}

void mouseReleased() 
{
    int col = mouseToCell(mouseX);
    int row = mouseToCell(mouseY);
    if (col >= 0 && row >= 0)
    {
        int hitCellIndex = cells[row][col];
        if (hitCellIndex != kEmptyCell)
        {
            // select
            currentCol = col;
            currentRow = row;
            pathfinder.setBot(0, currentRow, currentCol);
        }
        else
        {
            if (currentCol >= 0 && currentRow >= 0)
            {
                // move
                // 0.path finding
                pathfinder.setTarget(0, row, col);
                if (!pathfinder.findPath(0, 0, false))
                {
                    return;
                }
                
                // 1.swap
                setIndex(row, col, cells[currentRow][currentCol]);
                setIndex(currentRow, currentCol, kEmptyCell);

                // 2.invalidate
                currentCol = kInvalidIndex;
                currentRow = kInvalidIndex;
                
                // 3.add new balls
                readyForNewBalls = true;
            }
        }
    }
}

void update()
{
    if (readyForNewBalls)
    {
        generateNewBalls(false);
    }
    checkFiveBalls();
}

void draw()
{
    update();
   
    background(0, 43, 54);
    {
        // the board background
        fill(7, 54, 66);
        rectMode(CORNER); 
        rect(kSpacing, kSpacing, kBoardSize, kBoardSize);
    }
    {
        // the board lines
        //    fill
        noFill();
        stroke(0, 43, 54);
        for (int row=0;row<kCellCount+1;row++)
        {
            float y = cellToDraw(row);
            line(kSpacing, y, kSpacing+kBoardSize, y);
        }

        for (int col=0;col<kCellCount+1;col++)
        {
            float x = cellToDraw(col);
            line(x, kSpacing, x, kSpacing+kBoardSize);
        }
    }
    {
        // balls
        for (int col=0; col<kCellCount; col++) 
        {
            for (int row=0; row<kCellCount; row++) 
            {
                if (cells[row][col] != kEmptyCell)
                {
                    int colorIndex = cells[row][col];
                    color clr = ballColors[colorIndex];
                    ellipseMode(CENTER);

                    if (col == currentCol && row == currentRow)
                    {
                        // draw the selected ball
                        stroke(2, 83, 84);
                        strokeWeight(3);
                        noFill();
                        ellipse(cellToDraw(col+0.5f), cellToDraw(row+0.5f), // (cx,cy)
                                kBallRadius*1.2f, kBallRadius*1.2f);// (w, h)
                    }
                    fill(clr);
                    noStroke();
                    strokeWeight(1);
                    ellipse(cellToDraw(col+0.5f), cellToDraw(row+0.5f), // (cx,cy)
                            kBallRadius, kBallRadius);// (w, h)
                }
            }
        }
    }
}

void generateNewBalls(boolean firstTime)
{
    int ballCount = firstTime ? kNewBallCount + 1 : kNewBallCount;
    for (int ball=0;ball<ballCount;ball++)
    {
        // random colors
        int index = int(random(ballColors.length));
        // random position
        while (true)
        {
            int row = (int)random(kCellCount);
            int col = (int)random(kCellCount);
            if (cells[row][col] == kEmptyCell)
            {
                setIndex(row, col, index);
                // print('('+row+","+col+")="+newBallIndices[ball]+"   ");
                print(index+"   ");
                emptyCellCount --;
                if (!firstTime)
                {
                    newBallCol[ball] = col;
                    newBallRow[ball] = row;
                    newBallIndices[ball] = index;
                }
                break;
            }
        }
        if (emptyCellCount <= 0)
        {
            // you lose
        }
    }
    print("\n");
    readyForNewBalls = false;
}

int index(int row, int col)
{
    return cells[row][col];
}

void setIndex(int row, int col, int index)
{
    cells[row][col] = index;
    pathfinder.setGrid(row, col, index != kEmptyCell ? -1 : 0);
}

void checkFiveBalls()
{
    final int kTestCellCount = kCellCount-kMinMatchBallCount+1;// to save computation
    // todo: combo

    ArrayList<PVector>[] initials = new ArrayList[4];
    PVector[] deltas = new PVector[4];
    {
        // dir#0
        initials[0] = new ArrayList<PVector>();
        for (int row=0; row<kCellCount; row++) 
        {
            initials[0].add(new PVector(row, 0));
        }
        deltas[0] = new PVector(0, 1);
        
        // dir#1
        initials[1] = new ArrayList<PVector>();
        for (int col=0; col<kCellCount; col++) 
        {
            initials[1].add(new PVector(0, col));
        }
        deltas[1] = new PVector(1, 0);
        
        // dir#2
        initials[2] = new ArrayList<PVector>();
        for (int row=0; row<kCellCount; row++) 
        {
            initials[2].add(new PVector(row, 0));
        }
        for (int col=0; col<kCellCount; col++) 
        {
            initials[2].add(new PVector(0, col));
        }
        deltas[2] = new PVector(1, 1);
        
        // dir#3
        initials[3] = new ArrayList<PVector>();
        for (int row=0; row<kCellCount; row++) 
        {
            initials[3].add(new PVector(row, 0));
        }
        for (int col=0; col<kCellCount; col++) 
        {
            initials[3].add(new PVector(kCellCount-1, col));
        }
        deltas[3] = new PVector(-1, 1);        
    }
    
    for (int dir=0;dir < 4;dir++)
    {
        for (PVector initial : initials[dir])
        {
            PVector head = initial.get();
            while (head.x >= 0 && head.x < kCellCount &&
                head.y >= 0 && head.y < kCellCount)
            {
                int idxForTest = index((int)head.x, (int)head.y);
                if (idxForTest != kEmptyCell)
                {
                    ArrayList<PVector> ballsToVanish = new ArrayList<PVector>();
                    PVector next = head.get();
                    ballsToVanish.add(head.get());
                    next.add(deltas[dir]);
                    while (next.x >= 0 && next.x < kCellCount &&
                        next.y >= 0 && next.y < kCellCount)
                    {
                        if (index((int)next.x, (int)next.y) != idxForTest)
                        {
                            head = next.get();
                            head.sub(deltas[dir]);// to save computation
                            break;
                        }
                        // println(head+"->"+next);
                        ballsToVanish.add(next.get());
                        next.add(deltas[dir]);
                    }
                    testBalls(ballsToVanish);                    
                }
                head.add(deltas[dir]);
            }
        }
    }
}

void testBalls(ArrayList<PVector> ballsToVanish)
{
    if (ballsToVanish.size() >= kMinMatchBallCount)
    {
        for (PVector pos : ballsToVanish)
        {
            print(pos.x+","+pos.y+" ");
            setIndex((int)pos.x, (int)pos.y, kEmptyCell);
        }
        println("");
    }
}

