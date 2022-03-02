from test_framework import generic_test

from sys import exit

def closest_int_same_bit_count(x: int) -> int:
    # TODO - you fill in here.
    num_unsigned_bits = 64
    for i in range(num_unsigned_bits):
        if (x>>i)&1 != (x>>i+1)&1:
            x ^= (1<<i)|(1<<(i+1))
            return x
    raise ValueError("All bits are the same")
    
        
        
        

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('closest_int_same_weight.py',
                                       'closest_int_same_weight.tsv',
                                       closest_int_same_bit_count))
