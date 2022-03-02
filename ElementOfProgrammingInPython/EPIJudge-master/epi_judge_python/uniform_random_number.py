import functools
import random
from sys import exit
import math
from test_framework import generic_test
from test_framework.random_sequence_checker import (
    check_sequence_is_uniformly_random, run_func_with_retries)
from test_framework.test_utils import enable_executor_hook


def zero_one_random():
    return random.randrange(2)


def uniform_random(lower_bound: int, upper_bound: int) -> int:
    # TODO - you fill in here.
    if lower_bound == upper_bound:
        return lower_bound
    
    distance = upper_bound - lower_bound + 1
    times = math.ceil(math.log2(distance))
    tail = lower_bound + 2**times - 1
    ans = upper_bound+1
    
    while ans>upper_bound:
        if zero_one_random() == 1:
            ans = uniform_random(math.ceil((lower_bound+tail)/2),tail)
        else:
            ans = uniform_random(lower_bound,math.floor((lower_bound+tail)/2))       
    
    return ans

def uniform_random(lower_bound: int, upper_bound: int) -> int:
    # TODO - you fill in here.    
    distance = upper_bound - lower_bound + 1
    n_digits = math.ceil(math.log2(distance)) + 1
   
    
    while True:
        ans = lower_bound
        for i in range(n_digits-1,-1,-1):
            digit = zero_one_random()
            ans = ans + (digit << i)
            if ans>upper_bound:
                break
            elif i==0:
                return ans
            
    
    
    



@enable_executor_hook
def uniform_random_wrapper(executor, lower_bound, upper_bound):
    def uniform_random_runner(executor, lower_bound, upper_bound):
        result = executor.run(
            lambda:
            [uniform_random(lower_bound, upper_bound) for _ in range(100000)])

        return check_sequence_is_uniformly_random(
            [a - lower_bound for a in result], upper_bound - lower_bound + 1,
            0.01)

    run_func_with_retries(
        functools.partial(uniform_random_runner, executor, lower_bound,
                          upper_bound))


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('uniform_random_number.py',
                                       'uniform_random_number.tsv',
                                       uniform_random_wrapper))
