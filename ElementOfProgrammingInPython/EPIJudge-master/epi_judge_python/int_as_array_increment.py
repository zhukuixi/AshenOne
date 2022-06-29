from typing import List

from test_framework import generic_test
from sys import exit

def plus_one(A: List[int]) -> List[int]:
    # TODO - you fill in here.
    extra = 0
    for i in reversed(range(0,len(A))):
        if i==len(A)-1:
            A[i] += 1
        else:
            A[i] += extra
        
        if A[i] >= 10:
            A[i] = 0
            extra = 1
        else:
            return A
    if extra>0:
        A[0]=1
        A.append(0)
        
    return A
        

    
        


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('int_as_array_increment.py',
                                       'int_as_array_increment.tsv', plus_one))
