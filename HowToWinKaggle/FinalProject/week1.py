# -*- coding: utf-8 -*-
"""
Created on Fri Feb  7 21:20:51 2020

@author: Kuixi Zhu
"""

import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt


DATA_FOLDER = 'D:/JooGitRepo/RainyNight/HowToWinKaggle/FinalProject/input/'

transactions    = pd.read_csv(os.path.join(DATA_FOLDER, 'sales_train.csv.gz'))
items           = pd.read_csv(os.path.join(DATA_FOLDER, 'items.csv'))
item_categories = pd.read_csv(os.path.join(DATA_FOLDER, 'item_categories.csv'))
shops           = pd.read_csv(os.path.join(DATA_FOLDER, 'shops.csv'))


# YOUR CODE GOES HERE
print(transactions.shape)
print(items.shape)
print(item_categories.shape)
print(shops.shape)

print(transactions.head())
print(items.head())
print(item_categories.head())
print(shops.head())

################## Q1 ##################
## method 1
date = transactions.date.str.split("\\.",expand=True)
date = date.astype('int')
transactions[['day','month','year']] = date
def getRev(df):
    return sum(df.item_price * df.item_cnt_day)
rev= transactions.loc[(transactions.month==9) & (transactions.year==2014),:].groupby('shop_id')['item_price','item_cnt_day'].apply(getRev).max()



## method 2
time_format='%d.%m.%Y'
transactions.date = pd.to_datetime(transactions.date,format=time_format)
transactions = transactions.set_index(['date'])
transactions = transactions.sort_index()
transactions['rev']=transactions.item_price*transactions.item_cnt_day
answer=transactions.loc[('2014-Sep'),:].groupby(['shop_id'])['rev'].agg({'rev':'sum'}).max()
max_revenue = float(answer)

################## Q2 ##################
## method 1

transactions_cate = pd.merge(transactions,items,on = 'item_id',how='left')
transactions_cate.loc[(transactions.month<=8) & (transactions.month>=6) & (transactions.year==2014)].groupby('item_category_id')['item_price','item_cnt_day'].apply(getRev).idxmax()

## method 2
transaction_itemCate = transactions.join(items,on=['item_id'],lsuffix="_transa",rsuffix='_item')
answer = transaction_itemCate.loc[slice('2014-Jun','2014-Aug'),:].groupby(['item_category_id'])['rev'].agg({'rev':'sum'}).idxmax()


################# Q3 ####################

## method 1
def countUnique(series):
    return series.nunique()

re = transactions.groupby('item_id')['item_price'].apply(countUnique)
num_items_constant_price = sum(re==1)


## method 2
def fun(input):
    return(len(input.unique()))

result = transaction_itemCate.groupby(['item_id_transa'])['item_price'].apply(fun)
num_items_constant_price = sum(result==1)

#What was the variance of the number of sold items per day sequence for the shop with shop_id = 25 in December, 2014? Do not count the items, that were sold but returned back later.


############### Q4 #######################
## method 1
total_num_items_sold = transactions.loc[(transactions.shop_id==25) & (transactions.month==12) & (transactions.year==2014)].groupby('day')['item_cnt_day'].apply(sum)
days = total_num_items_sold.index
total_num_items_sold_var = np.var(total_num_items_sold)

## method 2
transaction_itemCate=transaction_itemCate.reset_index()
transaction_itemCate=transaction_itemCate.set_index(['date','shop_id'])
transaction_itemCate=transaction_itemCate.sort_index()

ans = transaction_itemCate.loc[('2014-Dec',25),:].groupby(['date'])['item_cnt_day'].agg({'item_cnt_day':'sum'}).reset_index()
total_num_items_sold = ans.item_cnt_day
days =ans.date

# Plot it
plt.plot(days, total_num_items_sold)
plt.ylabel('Num items')
plt.xlabel('Day')
plt.title("Daily revenue for shop_id = 25")
plt.show()

total_num_items_sold_var = np.var(total_num_items_sold,ddof=len(days)-1)

## apply and transform difference
   # apply对全局,结果的shape可以改变
   # transform对每一个series，结果而且axis方向的长度不变
## use & | ^ ~ 来做dataframe的boolean access! 而不是and or not
## 对time的处理！





