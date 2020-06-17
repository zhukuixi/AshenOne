#Chapter 1. Introduction

## 1.1 Example: Polynomial Curve Fitting
数据一共有10个样本,用如下多项式模型进行拟合，用不同的M，也即不同复杂度的模型。    
![](https://github.com/zhukuixi/AshenOne/blob/master/PRML/Images/Chapter1_1.1.png)

发现模型随着参数个数M，从欠拟合，刚好，到过拟合  
![](https://github.com/zhukuixi/AshenOne/blob/master/PRML/Images/Chapter1_Fig1.5.png)

而且发现系数w随着模型随着M增高，magnitude of the coefficients变得越来越大  
![](https://github.com/zhukuixi/AshenOne/blob/master/PRML/Images/Chapter1_Tabble1.1.png)

于是为参数的magnitude加入惩罚，放入error function中  
![](https://github.com/zhukuixi/AshenOne/blob/master/PRML/Images/Chapter1_1.4.png)
