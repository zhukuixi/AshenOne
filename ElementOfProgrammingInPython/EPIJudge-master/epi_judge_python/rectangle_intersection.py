import collections

from sys import exit
from test_framework import generic_test
from test_framework.test_failure import PropertyName

Rect = collections.namedtuple('Rect', ('x', 'y', 'width', 'height'))


def intersect_rectangle(r1: Rect, r2: Rect) -> Rect:
    # TODO - you fill in here.
    def isnot_intersect(r1,r2):
        x_flag,y_flag = False,False
        ## X no intersect
        if r1.x>r2.x+r2.width or  r2.x>r1.x+r1.width :
            x_flag = True
        ## Y no intersect
        if r1.y>r2.y+r2.height or r2.y>r1.y+r1.height :
            y_flag = True
        ## Summary
        if x_flag or y_flag:
            return True
        else:
            return False
        
    if isnot_intersect(r1,r2):
        return Rect(0, 0, -1, -1)
    else:
        return Rect(max(r1.x,r2.x), max(r1.y,r2.y), min(r1.x+r1.width,r2.x+r2.width)-max(r1.x,r2.x), min(r1.y+r1.height,r2.y+r2.height)-max(r1.y,r2.y))
        
        


def intersect_rectangle_wrapper(r1, r2):
    return intersect_rectangle(Rect(*r1), Rect(*r2))


def res_printer(prop, value):
    def fmt(x):
        return [x[0], x[1], x[2], x[3]] if x else None

    if prop in (PropertyName.EXPECTED, PropertyName.RESULT):
        return fmt(value)
    else:
        return value


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('rectangle_intersection.py',
                                       'rectangle_intersection.tsv',
                                       intersect_rectangle_wrapper,
                                       res_printer=res_printer))
