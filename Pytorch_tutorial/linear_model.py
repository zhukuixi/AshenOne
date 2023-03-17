# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 11:51:31 2023

@author: Kuixi Zhu
"""
import numpy as np
import matplotlib.pyplot as plt

x_data = np.array([[1],[2],[3]])
y_data = np.array([2,4,6]).reshape(-1,1)


def forward(x,w):
    return x.dot(w)

def mse_loss(y_pred,y):
    return np.power(y_pred-y,2).mean()

w_list = np.arange(0,4.1,0.1)
mse_list = []

for w in w_list:
    y_pred = forward(x_data,w.reshape(1,-1))
    mse_list.append( mse_loss(y_pred,y_data))
    print("current loss:{:2.3} current w: {:2.3}".format(mse_list[-1],w) )

plt.plot(w_list,mse_list)
plt.ylabel("Loss")
plt.xlabel('w')
plt.show()