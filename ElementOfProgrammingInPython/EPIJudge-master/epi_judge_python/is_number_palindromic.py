from test_framework import generic_test

from sys import exit
import math

def is_palindrome_number(x: int) -> bool:
    # TODO - you fill in here.
    if x<0:
        return False
    if x==0:
        return  True
    N = math.floor(math.log(x,10))+1    
    for i in range(N//2):
        LSB = x%10
        MSB = x//10**(N-1-i*2)
        if LSB != MSB:
            return False
        x -= MSB*10**(N-1-i*2)+LSB
        x /= 10
        
    return True
        
        



   

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('is_number_palindromic.py',
                                       'is_number_palindromic.tsv',
                                       is_palindrome_number))
