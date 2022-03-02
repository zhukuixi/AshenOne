from test_framework import generic_test

from sys import exit

# def reverse(x: int) -> int:
#     # TODO - you fill in here.
#     if x<0:
#         return -1*reverse(-1*x)
    
#     power = 0
#     while 10**power<=x:        
#         power += 1
#     power -= 1
#     max_power = power
#     ans = 0 
#     while power>-1:
#         digit = x//(10**power)
#         ans += digit*(10**(max_power-power))
#         x -= digit*(10**power)
#         power -= 1
#     return ans
        
        
def reverse(x: int) -> int:
   # TODO - you fill in here.
   result, x_remaining = 0,abs(x)
   while x_remaining:        
       result = result*10 + x_remaining%10
       x_remaining = x_remaining//10
   return result if x>0 else -result

       
   
               
        
        
        

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('reverse_digits.py',
                                       'reverse_digits.tsv', reverse))
