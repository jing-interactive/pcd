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

