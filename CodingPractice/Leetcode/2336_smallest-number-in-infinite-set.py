class SmallestInfiniteSet:

    def __init__(self):
        self.minHeap = []
        self.pointer = 1
        self.visited = set()

    def popSmallest(self) -> int:
        if len(self.minHeap) >0:
            ele = heapq.heappop(self.minHeap) 
            self.visited.remove(ele)
            return ele
        else:
            self.pointer += 1            
            return self.pointer - 1
        

    def addBack(self, num: int) -> None:
        if num < self.pointer and num not in self.visited:
            heapq.heappush(self.minHeap,num)
            self.visited.add(num)
        
        

        


# Your SmallestInfiniteSet object will be instantiated and called as such:
# obj = SmallestInfiniteSet()
# param_1 = obj.popSmallest()
# obj.addBack(num)