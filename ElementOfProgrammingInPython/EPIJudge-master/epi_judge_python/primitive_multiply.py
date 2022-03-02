from test_framework import generic_test

from sys import exit

# def multiply(x: int, y: int) -> int:
#     # TODO - you fill in here.
#     def add(a,b):
#         return a if b==0 else add(a^b,(a&b)<<1)    
#     result = 0
#     while x:
#         if x&1:
#             result = add(result,y)
#         x >>= 1
#         y <<= 1
        
#     return(result)
        

def multiply(x: int, y: int) -> int:
    # TODO - you fill in here.
    def add(a,b)        :
        return a if b==0 else add(a^b,(a&b)<<1)
    
    result = 0     
    while x:
        if x&1:
            result = add(result,y)
        y <<= 1
        x >>= 1
    return result        
            
        


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('primitive_multiply.py',
                                       'primitive_multiply.tsv', multiply))
