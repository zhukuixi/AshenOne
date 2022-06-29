from typing import List

from test_framework import generic_test
from sys import exit

def can_reach_end(A: List[int]) -> bool:
    # TODO - you fill in here.
    lastReach = len(A)-1
    for i in reversed(range(len(A))):
        if i+A[i]>=lastReach:
            lastReach = i
            
    return True if lastReach==0 else False
        
def can_reach_end(A: List[int]) -> int:
    # TODO - you fill in here.
    furthestIndex = 0
    i = 0
    while i<=furthestIndex:
        furthestIndex = max(furthestIndex,A[i]+i)
        if furthestIndex>=len(A)-1:
            return True
        i += 1
    return False
                
def can_reach_end_var(A: List[int]) -> int:
    # TODO - you fill in here.
    lastReach = len(A)-1
    store = {(len(A)-1):0}
    
    for i in reversed(range(len(A)-1)):
        if i+A[i]>=lastReach:
            store[i] = 1            
        else:
            store[i] = math.inf
            for j in range(i+1,A[i]+i+1):
                store[i] = min(store[i],store[j])
            store[i]+=1
    return store[0]

            
            

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('advance_by_offsets.py',
                                       'advance_by_offsets.tsv',
                                       can_reach_end))
