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

boolean readyForNewBalls = true;

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
        }
        else
        {
            if (currentCol >= 0 && currentRow >= 0)
            {
                // move
                // 1.swap
                cells[row][col] = cells[currentRow][currentCol];
                cells[currentRow][currentCol] = kEmptyCell;
                // 2.invalidate
                currentCol = kInvalidIndex;
                currentRow = kInvalidIndex;
                // 3.add new balls
                readyForNewBalls = true;
            }
            else
            {
                // select
                currentCol = col;
                currentRow = row;        
            }
        }
    }
}

void update()
{
    if (readyForNewBalls)
    {
        generateNewBalls();
    }
    checkFiveBalls();
    // if (currentCol >= 0 && currentRow >= 0)
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

void generateNewBalls()
{
    for (int ball=0;ball<kNewBallCount;ball++)
    {
        // random colors
        for (int i=0;i<10;i++)
            newBallIndices[ball] = int(random(ballColors.length));
        // random position
        while (true)
        {
            int row = (int)random(kCellCount);
            int col = (int)random(kCellCount);
            if (cells[row][col] == kEmptyCell)
            {
                newBallCol[ball] = col;
                newBallRow[ball] = row;
                cells[row][col] = newBallIndices[ball];
                // print('('+row+","+col+")="+newBallIndices[ball]+"   ");
                print(newBallIndices[ball]+"   ");
                emptyCellCount --;
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

void checkFiveBalls()
{
    final int kTestCellCount = kCellCount-kMinMatchBallCount+1;// to save computation
    // todo: combo

    // for each row
    for (int row=0; row<kCellCount; row++) 
    { 
        for (int col=0; col<kTestCellCount; col++) 
        {
            int idxForTest = index(row, col);
            if (idxForTest != kEmptyCell)
            {
                ArrayList<PVector> ballsToVanish = new ArrayList<PVector>();
                ballsToVanish.add(new PVector(row, col));
                for (int nextCol=col+1; nextCol<kCellCount; nextCol++) 
                {
                    if (index(row, nextCol) != idxForTest)
                    {
                        col = nextCol-1;// to save computation
                        break;
                    }
                    ballsToVanish.add(new PVector(row, nextCol));
                }
                if (ballsToVanish.size() >= kMinMatchBallCount)
                {
                    println(ballsToVanish.size());
                    for (PVector pos : ballsToVanish)
                    {
                        cells[(int)pos.x][(int)pos.y] = kEmptyCell;
                    }
                }
            }
        }
    }
   
    // for each col
    for (int col=0; col<kCellCount; col++) 
    { 
        for (int row=0; row<kTestCellCount; row++) 
        {
            int idxForTest = index(row, col);
            ArrayList<PVector> ballsToVanish = new ArrayList<PVector>();
            ballsToVanish.add(new PVector(row, col));
            if (idxForTest != kEmptyCell)
            {
                for (int nextRow=row+1; nextRow<kCellCount; nextRow++) 
                {
                    if (index(nextRow, col) != idxForTest)
                    {
                        row = nextRow-1;// to save computation
                        break;
                    }
                    ballsToVanish.add(new PVector(nextRow, col));
                }
            }
            if (ballsToVanish.size() >= kMinMatchBallCount)
            {
                for (PVector pos : ballsToVanish)
                {
                    cells[(int)pos.x][(int)pos.y] = kEmptyCell;
                }
            }
        }
    }
}

