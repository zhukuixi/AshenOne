from test_framework import generic_test
from sys import exit


def power(x: float, y: int) -> float:
    if y<0:
        return 1/power(x,-y)
    # TODO - you fill in here.
    tmp_x = 1
    ans = 1
    while y:
        tmp_x = x if tmp_x==1 else tmp_x**2
        if y&1:
            ans *= tmp_x
        y>>=1
    return ans
  


if __name__ == '__main__':
    exit(generic_test.generic_test_main('power_x_y.py', 'power_x_y.tsv',
                                        power))
