from test_framework import generic_test
from sys import exit

def reverse(x: int) -> int:
    # TODO - you fill in here.
    if x<0:
        return -reverse(-x)
    
    ans = 0
    while x:
        lsb = x%10
        x//=10
        ans = ans*10+lsb
        
    
        
    return ans


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('reverse_digits.py',
                                       'reverse_digits.tsv', reverse))
