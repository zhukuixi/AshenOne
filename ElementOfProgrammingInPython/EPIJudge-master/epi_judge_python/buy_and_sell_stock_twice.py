from typing import List

from test_framework import generic_test
from sys import exit

def buy_and_sell_stock_twice(prices: List[float]) -> float:
    # TODO - you fill in here.
    minBuyinPrices = prices[0]
  
    maxProfit1 = [0]*len(prices)
    
    
    # TODO
    ## forward
    maxProfit_sofar = 0
    for i in range(1,len(prices)):
        currentProfit1 =  prices[i]-minBuyinPrices
        maxProfit1[i] = max(maxProfit_sofar,currentProfit1)
        if currentProfit1>maxProfit_sofar:
            maxProfit_sofar = currentProfit1
        if prices[i]<minBuyinPrices:
            minBuyinPrices = prices[i]
            
     
        
    maxSellPrices = prices[-1]
    maxProfit2 = [0]*len(prices)
    maxProfit_total = 0
    maxProfit_sofar = 0
    for i in reversed(range(len(prices)-1)):
        currentProfit2 =  maxSellPrices - prices[i]
        maxProfit2[i] = max(maxProfit_sofar,currentProfit2)
        if currentProfit2>maxProfit_sofar:
            maxProfit_sofar = currentProfit2
        if maxProfit_total<maxProfit2[i] + maxProfit1[i]:
            maxProfit_total=maxProfit2[i] + maxProfit1[i]
        if prices[i]>maxSellPrices:
            maxSellPrices = prices[i]
    
    return maxProfit_total


if __name__ == '__main__':
    exit(
        generic_test.generic_test_main('buy_and_sell_stock_twice.py',
                                       'buy_and_sell_stock_twice.tsv',
                                       buy_and_sell_stock_twice))
