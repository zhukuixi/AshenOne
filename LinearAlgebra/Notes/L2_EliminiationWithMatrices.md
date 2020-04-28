#Lecture 2. Elimination with matrices
* The basic operation of elimination of matrices
	> * pivot为零的pivot行试图与下面非零pivot行换行
	> * pivot所在行乘以常数与pivot下方的行相消
![Page1](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L2_1.jpg)  

## 情景Ax=b， A为方阵
在A矩阵elimination后，如果所有pivot都为非零，则是**可逆**的。  
> * Ax=b有唯一解。
> *  从U的元素分布形状易知，对变量从下往上逐一带入求得唯一解

如果有pivot为零,则矩阵是**不可逆**的。
> * Ax=b有无穷解或者无解。
> *  从U的元素分布形状易知,此时U存在全零行。如果此时b和全零行对应得元素为非零，则无解。否则，则有无穷解。









