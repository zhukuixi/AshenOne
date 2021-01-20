## 3天熟悉Kaggle-CV竞赛全流程

### Kaggle-Kernel教程 
以肾小球比赛（code competiton)为例,介绍如何加载模型，权重，自定义上传的数据。
    
	[快速测试A榜] https://www.kaggle.com/finlay/csv-write-for-fast-public-score   

	[通用方法，A,B榜都可以打，一般用这种] https://www.kaggle.com/wrrosa/hubmap-tf-with-tpu-efficientunet-512x512-subm


### 赛题解析+baseline思路（试听课-小麦-CV里的目标检测）
 - 如何分析赛题，解决赛题任务？
 - 目标检测类比赛通用套路（数据分析，算法选择，算法优化）
 - 最先进的目标检测类算法实战原理（**efficientDet,yolov5**)
 - 初级，高级提分Trick(数据增强，训练策略，模型融合）
	
	1. Kaggle平台简介  
     	 -赛题分类：在线提交比赛，离线提交比赛
	     -比赛通用流程：EDA->特征工程->模型训练->线下验证

	2. 赛题背景分析  
		 -目标：把图像中小麦头的位置框(bbox)选出来  
	     -比赛难点：  
			1.密集小麦植株经常重叠 （多个小麦头**重叠**）  
		    2.风会使照片**模糊**  
            3.外观因成熟度，颜色，基因型和头部方向而**异**    
         -数据介绍：  
            训练集3422张，测试集10张 （A榜）  
         -数据样本分析：  
			  训练集样本bbox分布的barplot(呈现正态分布)
![](https://github.com/zhukuixi/RainyNight/blob/master/KaggleTraining/Image/1.png)
  
	3. Baseline思路介绍  
	     -
	