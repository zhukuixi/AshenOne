from test_framework import generic_test

from sys import exit

def closest_int_same_bit_count(x: int) -> int:
    # TODO - you fill in here.
    a = (x>>1)^x
    bit_mask = a&~(a-1)
    bit_mask |= bit_mask<<1
    x ^= bit_mask
    return x
    

        

        
        
        
        

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('closest_int_same_weight.py',
                                       'closest_int_same_weight.tsv',
                                       closest_int_same_bit_count))
