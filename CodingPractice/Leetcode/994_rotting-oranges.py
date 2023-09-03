class Solution:
    def orangesRotting(self, grid: List[List[int]]) -> int:
        
        def getStartingRotten(grid):
            rotten = []
            fresh_count = 0
            for r_index,row in enumerate(grid):
                for c_index, value in enumerate(row):
                    if value == 2:
                        rotten.append((r_index,c_index))
                    if value == 1:
                        fresh_count += 1

            return rotten,fresh_count
                
        def bfs(rotten,fresh_count:int, grid:List[List[int]]) -> int:
            timer = 0
            if fresh_count == 0:
                return 0
            
         
            m,n = len(grid),len(grid[0])
            infected = []
            while rotten:
                
                row,col = rotten.pop(0)
                neighbors = [(row-1,col),(row+1,col),(row,col-1),(row,col+1)]
                for r,c in neighbors:
                    # out of bound
                    if r<0 or r==m or c<0 or c==n:
                        continue
                    
                    if grid[r][c]==1:
                        grid[r][c]=2
                        fresh_count -= 1
                        infected.append((r,c))
             
                if len(rotten) == 0:
                    timer += 1                   
                    if fresh_count == 0:
                        return timer
                    rotten = infected
                    infected = []

            if fresh_count!=0:
                return -1
    
                        


                    
                

                
                


                    


          
        


        rotten,fresh_count = getStartingRotten(grid)
        print(rotten)
        ans = bfs(rotten,fresh_count,grid)
        return ans


        