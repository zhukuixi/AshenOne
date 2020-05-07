# Lecture 7. Solving Ax = 0: pivot variables, special solutions
* 获取矩阵**A**的nullspace:   
> Step 1:获取**A**x=0的特解   
> Step 2:**A**的nullsapce由这些特解的自由线性组合支撑起来.    

* Pivot variables and free variables
* Special Solutions  

## Ax = 0 , UX = 0 , Rx = 0

* **Step 1**. 消元,找pivot。pivot可以理解为对所在这一行维度的填充者。
> *  【思：所以说rank（pivot的个数）这个概念对一个空间的填充性进行描述，表示对于这个N维空间，有rank个维度可以任意填满，其余的无法任意填满.】      
> * pivot所对应的列为pivot column;非pivot列所对应的列是free column.    
      
* **Step 2**.对free column所对应变量挨个赋值1（其余赋值0），则能得到一个特解。如果有3个free column则对这三个自由变量赋值3次，依次为[1,0,0],[0,1,0],[0,0,1].
> * 【思：这样赋值，可以保证特解直接是独立的！】  
> * 若矩阵为M*N，消元后发现有r个pivot,则称矩阵的rank为r。此时有n-r个free column,也即n-r个特解且是独立的。这些特解支撑起nullspace,因此nullspace的rank为n-r。
> * 上一条说了，矩阵的rank为r.之前我的思考是rank是描述空间的填充性，那么矩阵的rank是什么意思？ 因为第一节课我们就讲了矩阵的row space,columns space。因此，我们联合起来，就是说矩阵的rank为r，意味着矩阵的row space和column space的rank均为r.这个矩阵代表的两种空间具有相等的填充性！
     

![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L7_1.jpg)  

后半笔记讲述了A化作R后的一些好处，感觉不是非常重要，化作U后足矣。    
![Page0](https://github.com/zhukuixi/RainyNight/blob/master/LinearAlgebra/Images/L7_2.jpg)
