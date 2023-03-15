from test_framework import generic_test


def divide(x: int, y: int) -> int:
    # TODO - you fill in here.
    if x < y:
        return 0
    else:
        ans = 1
        y_temp=y
        while x>=y_temp:
            y_temp<<=1
            ans<<=1
        y_temp>>=1
        ans>>=1
        return ans + divide(x-y_temp,y)
    
def divide(x: int, y: int) -> int:
    # TODO - you fill in here.
    if x<y:
        return 0
    
    y_power = y
    power = 0 
    while x>=y_power:
        y_power <<= 1
        power += 1
        
    ans = 0
    y_power >>= 1
    power -= 1
    ans += 1<<power
    x -= y_power
    
    while x>=y:
        while y_power>x:
            y_power>>=1
            power -= 1
        ans += 1<<power
        x -= y_power
        
    
    return ans
            
        
    
        
        
        
        
    

if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('primitive_divide.py',
                                       'primitive_divide.tsv', divide))
