class Solution:
    def nearestExit(self, maze: List[List[str]], entrance: List[int]) -> int:      
        stack = deque([(entrance[0],entrance[1])])
        maze[entrance[0]][entrance[1]] = "+"
        next_step = deque()
        row,column = len(maze),len(maze[0])
        step = 0
        while stack:
            x,y = stack.popleft()          
            for dx,dy in [(-1,0),(1,0),(0,1),(0,-1)]:
                explore_x = x + dx
                explore_y = y + dy

                if explore_x <0 or explore_x == row or explore_y < 0 or explore_y ==column or  \
                maze[explore_x][explore_y]=="+" :                    
                    continue                
                else:
                    if (explore_x,explore_y)!=(entrance[0],entrance[1]) and maze[explore_x][explore_y]=="." and ((explore_x==0 or explore_x== row-1) or (explore_y==0 or explore_y==column-1)) :
                         return step+1
                    else:
                        maze[explore_x][explore_y] = '+'
                        next_step.append((explore_x,explore_y))
            
            if len(stack) ==0:                    
                step += 1
                stack = next_step
                next_step = deque()

        return -1
    
     

                    

             
            
        