//Conway's Game of Life

int[][] mylife;
int[][] newlife;
int gamesize1 = 750;
int gamesize2 = 500;
int lifefactor1 = 5; //Size of game must be lifesize*lifefactor
int lifefactor2 = 5;
int lifesize1 = gamesize1/lifefactor1;
int lifesize2 = gamesize2/lifefactor2;

void setup()
{
  size(750,500);
  background(255);
  mylife = new int[lifesize1][lifesize2];
  newlife = new int[lifesize1][lifesize2];
  for (int i = 0;i<lifesize1;i++)
  {
   for (int j = 0;j<lifesize2;j++)
    {
     mylife[i][j] = int(random(2));   
    }
  }
}


void draw()
{
  frameRate(15);
  background(255);
  spy(mylife);
  int num_neighbors;
  for (int i = 0;i<lifesize1;i++)
  {
    for (int j = 0;j<lifesize2;j++)
    {
      newlife[i][j] = mylife[i][j];
      num_neighbors = compute_neighbors(mylife,i,j);
      if (mylife[i][j] == 1)
      {
         //Any live cell with fewer than two live neighbor dies
        if (num_neighbors < 2)
         {
           newlife[i][j] = 0;
         } 
         //Any live cell with more than three live neighbors dies
         else if (num_neighbors > 3)
         {
           newlife[i][j] = 0; 
         }
      }
      else
      {
        //any dead cell with exactly three neighbors becomes a live cell
        if (num_neighbors == 3)
         {
            newlife[i][j] = 1; 
         }
      }
    }
  }
  for (int i = 0;i<lifesize1;i++)
  {
    for (int j = 0;j<lifesize2;j++)
    {
      mylife[i][j] = newlife[i][j];
    }
  }
}

int compute_neighbors(int[][] life,int i,int j)
{
  int left = i-1;
  if (left == -1) {left = lifesize1-1;}
  int right = i+1;
  if (right == lifesize1) {right = 0;}
  int top = j+1;
  if (top == lifesize2) {top = 0;}
  int bottom = j-1;
  if (bottom == -1) {bottom = lifesize2-1;} 
  int n = life[left][j] + life[right][j] + life[i][top] + life[i][bottom];
  n = n + life[left][top] + life[left][bottom] + life[right][top] + life[right][bottom];
 
 return n; 
}

void spy(int[][] life)
{
 for (int i = 0;i<lifesize1;i++)
  {
    for (int j = 0;j<lifesize2;j++)
    {
      if (life[i][j] == 1)
      {
        //fill(0,0,255);
        rect(lifefactor1*i,lifefactor2*j,lifefactor1,lifefactor2);
        //print("One's alive");
      }
    }
  }
}
