# Lecture 21: Eigenvalues and Eigenvectors
* N by N matrix got N eigen values and N eigen vectors
* Det(A-lambda*I) = 0
* A对角线元素加和 = 特征根的加和！
* Det(A) = 特征根的乘积！


![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/LC21_1.jpg)  
  
此处阐述了如何利用 "Det(A-lambda*I) = 0" 来求解eigen value和eigen vector.  
1. 先求lambda  
2. 套入lambda,求解A-lambda*I的nullspace，即得eigen vector

### 一种特殊情况：A与A+c*I时候
> eigenvector不变，每个eigenvalue的改变为constant c.
> 
![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/LC21_2.jpg)

### 例子
![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/LC21_3.jpg)