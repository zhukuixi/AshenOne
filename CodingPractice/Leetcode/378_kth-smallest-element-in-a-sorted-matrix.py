class Solution:
    def kthSmallest(self, matrix: List[List[int]], k: int) -> int:
        n = len(matrix)
        maxRow = min(n,k)
        minHeap = [ (row[0],i)  for i,row in enumerate(matrix[:maxRow]) ]
        heapq.heapify(minHeap)

        index_record = [0]*maxRow
        result = None
        for i in range(k):
            result,row_index = heapq.heappop(minHeap)
            index_record[row_index] += 1            
            if index_record[row_index] < n:
                new_element = matrix[row_index][index_record[row_index]] 
                heapq.heappush(minHeap,(new_element,row_index))
        
        return result




        
     
            
        
        