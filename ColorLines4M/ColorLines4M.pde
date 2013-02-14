final color[] ballColors = {
    color(74, 132, 150), // red
    color(111, 30, 30), // coffee
    color(153, 153, 153), // yellow
    color(14, 160, 0), // green
    color(42, 125, 89), // blue
    color(181, 137, 21), // purple
    color(20, 20, 20), // black
};

final int kCellCount = 9;
final int kBallRadius = 40;
final int kSpacing = kBallRadius/2;
final int kCellSize = int(kBallRadius*1.4f);
final int kBoardSize = kCellSize * kCellCount;
final int kNewBallCount = 3;
final int kMinMatchBallCount = 5;

int score = 0;

final int kEmptyCell = -1;
final int kInvalidIndex = -11;

int[][] cells = new int[kCellCount][kCellCount];
int[] newBallIndices = new int[kNewBallCount];
int[] newBallCols = new int[kNewBallCount];
int[] newBallRow = new int[kNewBallCount];

int currentCol, currentRow;
int targetCol, targetRow;

boolean readyForNewBalls;
Pathfinder pathfinder;

void setup()
{
    size(600, 600);
//    orientation(PORTRAIT);
    frameRate(30);
    textAlign(LEFT);
    textSize(30);
    
    resetGame();
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
                if (checkFiveBalls())
                    readyForNewBalls = false;
                else
                    readyForNewBalls = true;
            }
        }
    }
}

void draw()
{
    if (readyForNewBalls)
    {
        generateNewBalls(false);
        checkFiveBalls();
    }
   
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
        // next three balls
        for (int ball=0; ball<kNewBallCount; ball++)
        {
            fill(ballColors[newBallIndices[ball]]);
            noStroke();
            strokeWeight(1);
            ellipse(cellToDraw(kCellCount+0.7f), cellToDraw(0.5f + ball), // (cx,cy)
                kBallRadius*0.5f, kBallRadius*0.5f);// (w, h)       
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
    fill(255);
    text("SCORE: "+score, kSpacing*2, height-kSpacing);
}

void generateNewBalls(boolean firstTime)
{
    int currentBallCount = 0;
    for (int col=0; col<kCellCount; col++) 
    {
        for (int row=0; row<kCellCount; row++) 
        {
            if (cells[row][col] != kEmptyCell)
            {
                currentBallCount++;
            }
        }
    }
    if (currentBallCount >= kCellCount*kCellCount - 3)
    {
        resetGame();
        return;
    }
                
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
                if (firstTime)
                {
                    setIndex(row, col, index);
                }
                else
                {
                    setIndex(row, col, newBallIndices[ball]);
                }
                // print('('+row+","+col+")="+newBallIndices[ball]+"   ");
                // print(index+"   ");
                if (ball < 3)
                {
                    newBallIndices[ball] = index;
                }
                break;
            }
        }
    }
    // print("\n");
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

boolean checkFiveBalls()
{
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
    
    ArrayList<PVector> totalBallsToVanish = new ArrayList<PVector>();
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
                    if (ballsToVanish.size() >= kMinMatchBallCount)
                    {
                        for (PVector p : ballsToVanish)
                            totalBallsToVanish.add(p);
                    }
                }
                head.add(deltas[dir]);
            }
        }
    }
    return testBalls(totalBallsToVanish);
}

boolean testBalls(ArrayList<PVector> ballsToVanish)
{
    if (ballsToVanish.isEmpty())
        return false;
        
    for (PVector pos : ballsToVanish)
    {
        // print(pos.x+","+pos.y+" ");
        setIndex((int)pos.x, (int)pos.y, kEmptyCell);
    }
    // println("");
    int size = ballsToVanish.size();
    score += size*10;
    if (size > kMinMatchBallCount)
        score += (size - kMinMatchBallCount)*(size - kMinMatchBallCount)*10;
        
    return true;
}

void resetGame()
{
    for (int col=0; col<kCellCount; col++) 
    {
        for (int row=0; row<kCellCount; row++) 
        {
            cells[row][col] = kEmptyCell;
        }
    }
    currentCol = currentRow = kInvalidIndex;
    targetCol = targetRow = kInvalidIndex;
    
    pathfinder = new Pathfinder(kCellCount, kCellCount, 1, 1);
    
    readyForNewBalls = false;
    generateNewBalls(true);
    score = 0;
}
//Pathfinding class: uses A* algorithm with a patch for unfinishable paths
class Pathfinder{
  int [][] grid;                                    //terrain costs, -1 for a wall positive numbers indicate difficult ground
  boolean [][] onList;                              //is a grid coord on the closed or open lists?
  Vec2 [] bot;                                      //chasing bots
  Vec2 [] target;                                   //targets
  int wide, high;                                   //size of world
  ArrayList openlist, closedlist;
  Pathfinder(int wide, int high, int numBots, int numTargets){
    this.wide = wide;
    this.high = high;
    grid = new int[wide][high];
    for(int i = 0; i < wide; i++){
      for(int j = 0; j < high; j++){
        grid[i][j] = 0;
      }
    }
    onList = new boolean[wide][high];
    bot = new Vec2[numBots];
    target = new Vec2[numTargets];
    openlist = new ArrayList();
    closedlist = new ArrayList();
  }
  
  //init or relocate bot
  void setBot(int id, int x, int y){
    bot[id] = new Vec2(x, y);
  }
  
  //init or relocate target
  void setTarget(int id, int x, int y){
    target[id] = new Vec2(x, y);
  }
  
  //set terrain costs or a wall
  void setGrid(int x, int y, int value){
    grid[x][y] = value;
  }
  
  //return the next best coord to move to to get to a locale
  Vec2 bestVec2(int botID, int targetID){
    findPath(botID, targetID, false);
    if(closedlist.size() > 1){
      ArrayList pathway = logicalPath(botID, targetID);
      return (Vec2)pathway.get(pathway.size() - 2);
    }
    return null;
  }
  
  //A* pathfinding algorithm
  boolean findPath(int botID, int targetID, boolean move){
    int x = bot[botID].x;
    int y = bot[botID].y;
    int targetX = target[targetID].x;
    int targetY = target[targetID].y;
    //cost is defined by F = G + H
    //G = grid movement cost (all equal in this version but stated for further development)
    //H = heuristic distance (derived from Manhattan formula: width + height from target)
    int G = 10;
    int H = 10 * (abs(x - targetX) + abs(y - targetY));
    //if heuristic cost is zero, pathfinding is unnecessary
    if(H == 0){
      return true;
    }
    //clear lists
    onList = new boolean[wide][high];
    openlist.clear();
    closedlist.clear();
    //add current locale
    closedlist.add(new Node(null, bot[botID], G + H));
    onList[x][y] = true;
    while(x != targetX || y != targetY){
      //add possible nodes to open list
      //straight line nodes
      if(gridLegal(x + 1, y) && !onList[x + 1][y]){
        H = 10 * (abs(x + 1 - targetX) + abs(y - targetY));
        openlist.add(new Node(new Vec2(x,y), new Vec2(x + 1, y), G + H + grid[x + 1][y]));
        onList[x + 1][y] = true;
      }
      if(gridLegal(x, y + 1) && !onList[x][y + 1]){
        H = 10 * (abs(x - targetX) + abs(y + 1 - targetY));
        openlist.add(new Node(new Vec2(x,y), new Vec2(x, y + 1), G + H + grid[x][y + 1]));
        onList[x][y + 1] = true;
      }
      if(gridLegal(x - 1, y) && !onList[x - 1][y]){
        H = 10 * (abs(x - 1 - targetX) + abs(y - targetY));
        openlist.add(new Node(new Vec2(x,y), new Vec2(x - 1, y), G + H + grid[x - 1][y]));
        onList[x - 1][y] = true;
      }
      if(gridLegal(x, y - 1) && !onList[x][y - 1]){
        H = 10 * (abs(x - targetX) + abs(y - 1 - targetY));
        openlist.add(new Node(new Vec2(x,y), new Vec2(x, y - 1), G + H + grid[x][y - 1]));
        onList[x][y - 1] = true;
      }
      
      //find lowest costing node and add to closed list
      int lowestCost = 10000;
      int lowestCostNode = -1;
      for(int i = 0; i < openlist.size(); i++){
        Node temp = (Node)openlist.get(i);
        if(temp.cost < lowestCost){
          lowestCost = temp.cost;
          lowestCostNode = i;
        }
      }
      //escape node search if the target cannot be found
      if(lowestCostNode == -1){
        return false;
      }
      Node temp = (Node)openlist.remove(lowestCostNode);
      closedlist.add(temp);
      x = temp.n.x;
      y = temp.n.y;
    }
    if(move){
      //create logical path to target
      if(closedlist.size() > 1){
        ArrayList pathway = logicalPath(botID, targetID);
        Vec2 temp = (Vec2)pathway.get(pathway.size() - 2);
        bot[botID].x = temp.x;
        bot[botID].y = temp.y;
      }
    }
    return true;
  }
  
  //creates a path to the target from the closed list
  ArrayList logicalPath(int botID, int targetID){
    ArrayList pathway = new ArrayList();
    pathway.add(target[targetID]);
    int x = target[targetID].x;
    int y = target[targetID].y;
    //check if path to target is complete
    //if not, generate path to lowest cost node
    Node test = (Node)closedlist.get(closedlist.size() - 1);
    if(test.n.x != x && test.n.y != y){
      pathway.clear();
      int G = 10;
      int H = 10 * (abs(bot[botID].x - x) + abs(bot[botID].y - y));
      int lowestCostNode = G + H;
      for(int i = 0; i < closedlist.size(); i++){
        Node temp = (Node)closedlist.get(i);
        if(temp.cost < lowestCostNode){
          x = temp.n.x;
          y = temp.n.y;
          lowestCostNode = temp.cost;
        }
      }
      //workaround for being already at the lowest cost node
      if(lowestCostNode == G + H){
        x = bot[botID].x;
        y = bot[botID].y;
        pathway.add(new Vec2(x, y));
      }
      pathway.add(new Vec2(x, y));
    }
    for(int i = closedlist.size() - 1; i > 0; i--){
      Node temp = (Node)closedlist.get(i);
      if(temp.n.x == x && temp.n.y == y){
        pathway.add(temp.p);
        x = temp.p.x;
        y = temp.p.y;
      }
    }
    return pathway;
  }
  
  //is a grid square filled or no?
  boolean gridLegal(int x, int y){
    if(x < 0 || x > wide - 1 || y < 0 || y > high - 1 || grid[x][y] < 0){
      return false;
    }
    return true;
  }
  
  //pathfinding node class
  class Node{
    Vec2 n, p;            //n = node's location, p = parent's location
    int cost;             //cost of reaching target
    Node(Vec2 p, Vec2 n, int cost){
      this.n = n;
      this.p = p;
      this.cost = cost;
    }
  }
}

//2D ArrayList class
static class Vec2{
  int x,y;
  Vec2(int x, int y){
    this.x = x;
    this.y = y;
  }
}
