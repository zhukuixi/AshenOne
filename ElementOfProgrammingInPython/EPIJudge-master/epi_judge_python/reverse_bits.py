from test_framework import generic_test

from sys import exit

def reverse_bits(x: int) -> int:
    bit_mask = 0xffff
    block_len = 16
    ans = lookup[x>>block_len*3$bit_mask]|
    lookup[x>>block_len*2&bit_mask]<<block_len*1|
    lookup[x>>block_len*1&bit_mask]<<block_len*2|
    lookup[x&bit_mask]<<block_len*3
    
    return ans


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('reverse_bits.py', 'reverse_bits.tsv',
                                       reverse_bits))
