# Paddle深度学习之视频分类
1. 任务与背景
2. 视频分类方法
3. 前沿进展
4. 课程实践

## 1. 任务与背景
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_1.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_2.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_3.png)  
### 数据集  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_4.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_5.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_6.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_7.png)   
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_8.png)   
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_9.png)   

### 传统方法v.s深度学习方法
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_10.png)   
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_11.png)   

### DeepLearning-CV方面回顾
* CNN
* RNN
* LSTM

![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_12.png)   
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_13.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_14.png)   

## 2. 视频分类方法
* 1.双流网络 (Two-stream Network)
* 2.静态图像特征聚合
* 3.3D卷积   

![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_15.png)   
### 1.双流网络
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_16.png)   

![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_17.png)  
  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_18.png)      
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_19.png)   
小总结  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_20.png)  

### 2.静态图像特征聚合
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_21.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_22.png)    
* LRCN (CNN + LSTM)  
* ActionVLAD
* Attention Cluster

#### LRCN (CNN+LSTM)     
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_23.png)   
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_24.png) 

#### ActionVLAD
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_25.png)  
#### Attention Cluster
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_26.png)  
小总结  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_27.png)  

### 3.3D卷积
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_28.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_29.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_30.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_31.png)  
小总结  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_32.png)  

## 3.前沿进展

#### ECO
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_33.png)  
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_34.png)  

#### MARS
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_35.png)  

### SlowFast
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_36.png)  

### 光流表示学习
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/PaddleDeepLearning/image/VC_37.png)  
