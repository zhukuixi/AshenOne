from typing import List

from test_framework import generic_test
from sys import exit

def multiply(num1: List[int], num2: List[int]) -> List[int]:
    # TODO - you fill in here.
    ans = [0]*(len(num1)+len(num2))
    
    sign = -1 if num1[0]*num2[0]<0 else 1
    num1[0],num2[0] = abs(num1[0]),abs(num2[0])
    
    
    for ind1 in reversed(range(len(num1))):
        for ind2 in reversed(range(len(num2))):
            ans[ind1+ind2+1] += num1[ind1]*num2[ind2]
            ans[ind1+ind2] +=  ans[ind1+ind2+1]//10
            ans[ind1+ind2+1] %= 10
    
    ## removing leading zeros
    ans = ans[next((i for i,e in enumerate(ans) if e !=0),len(ans)):] or [0]
    ans = [ans[0]*sign]+ans[1:]

   
    
    return ans
    
        

            
            
          
            
            
            
 
if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('int_as_array_multiply.py',
                                       'int_as_array_multiply.tsv', multiply))
