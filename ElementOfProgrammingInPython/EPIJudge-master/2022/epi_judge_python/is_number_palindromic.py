from test_framework import generic_test
from sys import exit

def is_palindrome_number(x: int) -> bool:
    # TODO - you fill in here.
    import math
    if x<=0:
        return x==0
   
    digitLength = math.floor(math.log10(x))+1
    temp = digitLength-1
    
    for  i in range(digitLength//2):
        msb = x//(10**temp)
        lsb = x%10
        if msb!=lsb:
            return False
        x %= 10**temp
        x //= 10
        temp -=2
        
        
        
    return True


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('is_number_palindromic.py',
                                       'is_number_palindromic.tsv',
                                       is_palindrome_number))

