from test_framework import generic_test
from sys import exit


def power(x: float, y: int) -> float:
    # TODO - you fill in here.
    if y<0:
        x = 1/x
        y = -y
    power = y
    result = 1
    while power:
        if power&1:
            result *= x
        power >>= 1
        x *= x
        
    return result


if __name__ == '__main__':
    exit(generic_test.generic_test_main('power_x_y.py', 'power_x_y.tsv',
                                        power))
