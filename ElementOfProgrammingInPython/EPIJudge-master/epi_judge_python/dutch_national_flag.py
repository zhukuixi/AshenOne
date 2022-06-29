import functools
from typing import List
from sys import exit

from test_framework import generic_test
from test_framework.test_failure import TestFailure
from test_framework.test_utils import enable_executor_hook

RED, WHITE, BLUE = range(3)


def dutch_flag_partition(pivot_index: int, A: List[int]) -> None:
    # TODO - you fill in here.
    next_lessInd = 0 
    next_equalInd = 0
    next_greaterInd = len(A)-1
    pivot = A[pivot_index]
    while next_equalInd <= next_greaterInd:
        if A[next_equalInd]<pivot:
            A[next_equalInd], A[next_lessInd] = A[next_lessInd],A[next_equalInd]
            next_lessInd += 1
            next_equalInd += 1
        elif A[next_equalInd]==pivot:
            next_equalInd += 1            
        elif A[next_equalInd]>pivot:
            A[next_equalInd], A[next_greaterInd] = A[next_greaterInd],A[next_equalInd]
            next_greaterInd -= 1
     

def dutch_flag_partition_var1(pivot_index: int, A: List[int]) -> None:           
    next_part1,next_part2=0,0
    next_part3 = len(A)-1
    while next_part1<=next_part3:        
        if A[next_part2]
    
        

@enable_executor_hook
def dutch_flag_partition_wrapper(executor, A, pivot_idx):
    count = [0, 0, 0]
    for x in A:
        count[x] += 1
    pivot = A[pivot_idx]

    executor.run(functools.partial(dutch_flag_partition, pivot_idx, A))

    i = 0
    while i < len(A) and A[i] < pivot:
        count[A[i]] -= 1
        i += 1
    while i < len(A) and A[i] == pivot:
        count[A[i]] -= 1
        i += 1
    while i < len(A) and A[i] > pivot:
        count[A[i]] -= 1
        i += 1

    if i != len(A):
        raise TestFailure('Not partitioned after {}th element'.format(i))
    elif any(count):
        raise TestFailure('Some elements are missing from original array')


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('dutch_national_flag.py',
                                       'dutch_national_flag.tsv',
                                       dutch_flag_partition_wrapper))
