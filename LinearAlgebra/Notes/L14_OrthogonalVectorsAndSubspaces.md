# Lecture 14: Orthogonal vectors and subspaces
* 垂直向量和垂直子空间  
![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L14_1.jpg)  

提到Orthogonal complement的概念


***
## 为下一讲Ax=b上的Porjection做出铺垫 
LC10讲了如何获取4个fundamental subspace的basis,其中有提到获取row space的basis.矩阵A经过若干row operations，perserve了row space。其实，这些代表row operation的矩阵乘积，也即左乘的矩阵E，是不可逆的，因为E不可逆，所以才有 A的row space = E\*A的row space。  
如果E是一个可逆的矩阵，则破坏了row space。(need check!L18有讲一个性质: 当A,B均为方阵时,有 det(A*B) = det(A)*det(B)！)  
【思：反之对于column space, 如果E是不可逆的,可以保证Col(A)=Col(A*E)吗？】

![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L14_2.jpg)  

注意此处有一定律 N(transpose(A)\*A) = N(A)。因为A是m*n,transpose(A)\*A是n\*n,有了这个法则后，如果A的rank为n（也即所有列独立），则能保证transpose(A)\*A是可逆矩阵。

