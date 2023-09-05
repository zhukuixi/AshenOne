class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        sorted_intervals = sorted(intervals,key = lambda x:x[0])
        minHeap = []
        heapq.heapify(minHeap)
        
        for start_time,end_time in sorted_intervals:
            if len(minHeap) == 0 :
                heapq.heappush(minHeap,end_time)
            elif start_time < minHeap[0]:
                heapq.heappush(minHeap,end_time)
            else:
                heapq.heappushpop(minHeap,end_time)

        return len(minHeap)
                
        
        