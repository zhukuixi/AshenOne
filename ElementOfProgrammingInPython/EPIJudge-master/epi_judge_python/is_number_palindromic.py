from test_framework import generic_test

from sys import exit
import math

def is_palindrome_number(x: int) -> bool:
    # TODO - you fill in here.
    if x<0:
        return False
    
    power = 0
    while 10**power<=x:
        power+=1
    power -= 1
    while power>0:
        LSB = x%10
        MSB = x//(10**power)
        if LSB!=MSB:
            return False
        x -= MSB*(10**power)
        x = x//10
        power -= 2           
    return True

def is_palindrome_number(x: int) -> bool:
    # TODO - you fill in here.
    if x<=0:
        return x==0
    
    n_digits = math.floor(math.log10(x))+1
    mask = 10**(n_digits-1)
    for i in range(n_digits//2):
        if x%10 != x//mask:
            return False
        x = x%mask
        x = x//10
        mask //= 100
    return True
    
   

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('is_number_palindromic.py',
                                       'is_number_palindromic.tsv',
                                       is_palindrome_number))
