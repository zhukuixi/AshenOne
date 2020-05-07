# Lecture 3. Multiplication and inverse matrices
* 看待矩阵乘法的五个不同视角
* Inverse of A
* Gauss-Jordan (find inverse of A)


## 看待矩阵乘法的五个不同视角
> * 右乘左，是右边矩阵的每一列对左边矩阵的所有列进行组合，捏合成为一列
> * 左乘右，是左边矩阵的每一行对右边矩阵的所有行进行组合，捏合成为一行  

![Page1](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L3_1.jpg) 

# Inverse of A
若矩阵不可逆，则存有非零 vector X,使得Ax=0.  

我们可以总结一下前三节讲座对可逆和不可逆矩阵的性质：

### Column Picture的角度1  -- Fill the Space                
> * 可逆：    A填满空间 
> * 不可逆：  A无法填满空间

### Column Picture的角度2 -- Column Independent
> * 可逆：    列全部independent
> * 不可逆：  存在列依赖能被其他列表示，也即存有非零Vector X,使得Ax=0。
> 
### Ax=b的角度                
> * 可逆：   唯一解 
> * 不可逆：  无解或无穷解

![Page1](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L3_2.jpg)  
这里Gauss-Jordan巧妙利用了矩阵乘法的第五个视角"Block"。


 












