from test_framework import generic_test

from sys import exit

# def divide(x: int, y: int) -> int:
#     # TODO - you fill in here.
    
#     result = 0 
#     power = 32
#     y_power = y<<power
#     while x>=y:
#         y_power = y<<1
#         power += 1
#         if y_power>x:
#             y_power<<=1
#             power -= 1
#         result = 1<<power
#         x -= y_power

def divide(x: int, y: int) -> int:
    # TODO - you fill in here.
    power = 32
    y_power = y<<power
    result = 0 
    while x>=y:
        while y_power>x:
            y_power >>= 1
            power -=1
        result += 1<<power
        x -= y_power
    return result


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('primitive_divide.py',
                                       'primitive_divide.tsv', divide))
