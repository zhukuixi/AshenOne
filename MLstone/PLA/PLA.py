# -*- coding: utf-8 -*-
"""
Created on Wed Jan 26 17:58:07 2022

@author: Kuixi Zhu
"""
import numpy as np

class PLA:
    def __init__(self,data,learningRate):
        self.x,self.y = np.split(data,[data.shape[1]-1],axis=1)
        self.x = np.insert(self.x,0,1,axis=1)        
        self.learningRate = learningRate
        self.w = np.zeros(self.x.shape[1])
        self.currentBestErrorRate = 1
        self.w_pocket = np.zeros(self.x.shape[1])
        
    def getSign(self,predictResult):
  
        ans = np.sign(predictResult)
        ans[ans==0] = -1
        ans = ans.reshape([-1,1])
        return ans
    
    def fit(self,seed,isPocket=False,Times=-1):
     
        flag = True
        updateCount = 0 
        np.random.seed = seed
        index = np.arange(self.x.shape[0])
        permuted_index = np.random.permutation(index)

        if isPocket and Times==-1:
            raise ValueError('For Pocket Algorithm, Please specify the number of iterations')
        while flag:
            error = 0
            for i in permuted_index:
                x_i = self.x[i,:]
                y_i = self.y[i]
                sign = 1 if y_i*self.w.dot(x_i)>0 else -1
               
                if sign < 0:
                    self.w = self.w + self.learningRate*y_i*x_i
                    if isPocket:
                        newPrediction = self.getSign(self.x.dot(self.w))
                        newErrorRate = (newPrediction!=self.y).sum()/(len(newPrediction))
                       
                  
                        # print('{0:3f} {1:3f} {2:d} {3:d}'.format(newErrorRate,self.currentBestErrorRate,i,updateCount))
                        # print(w0)
                        if newErrorRate < self.currentBestErrorRate:
                            self.currentBestErrorRate = newErrorRate
                            self.w_pocket = np.copy(self.w)
                         
                        
                    updateCount += 1    
                    error += 1
                    
                    if isPocket and updateCount==Times:                          
                        return [self.w_pocket,updateCount]
                    
                    if Times!=-1 and not isPocket and updateCount==Times:  
                        return [self.w,updateCount]
                    
          
                
      
            if error == 0:
                flag = False
        print(updateCount)
        return [self.w,updateCount]
        
    def predict(self,input_x):
        result = input_x.dot(self.w)
        result = np.array([1 if ele>0 else -1 for ele in result])
        return result
    
    def predict_pocket(self,input_x):
        result = input_x.dot(self.w_pocket)
        result = np.array([1 if ele>0 else -1 for ele in result])
        return result
 
                
            
        


if __name__ == '__main__':
    # data = np.loadtxt('D:\JooGitRepo\RainyNight\MLstone\PLA\data.txt')
    # ans = []
    # for i in range(2000):
    #     pla_clf = PLA(data=data,learningRate=0.5)
    #     w,count = pla_clf.fit(seed=i)
    #     ans.append(count)
    # print(np.average(ans))
    # 40
    
    ## Pocket ##
    
    trainData_pocket = np.loadtxt('D:\JooGitRepo\RainyNight\MLstone\PLA/trainData_pocket.txt')
    testData_pocket = np.loadtxt('D:\JooGitRepo\RainyNight\MLstone\PLA/testData_pocket.txt')

    testData_pocket_x,testData_pocket_y = np.split(testData_pocket,[testData_pocket.shape[1]-1],axis=1)
    testData_pocket_x = np.insert(testData_pocket_x,0,1,axis=1)
    
    ## Pocket Run ##
    # ans = []
    # for i in range(2000):
    #     pla_clf = PLA(data=trainData_pocket,learningRate=1)
    #     pla_clf.fit(seed=i,isPocket=True,Times=100)
    #     predict_y = pla_clf.predict_pocket(testData_pocket_x)
    #     errorRate = sum(testData_pocket_y.flatten()!=predict_y.flatten())/testData_pocket_y.shape[0]
    #     ans.append(errorRate)
    #     print('{0:d} {1:3f}'.format(i,np.average(ans)))

    # print(np.average(ans))
    ## 0.13 for Times = 50
    ## 0.11 for Times = 100
    
    # Original PLA 50 run ##
    ans = []
    for i in range(2000):
        pla_clf = PLA(data=trainData_pocket,learningRate=1)
        w,count = pla_clf.fit(seed=i,isPocket=False,Times=100)
        predict_y = pla_clf.predict(testData_pocket_x)
        errorRate = sum(testData_pocket_y.flatten()!=predict_y.flatten())/testData_pocket_y.shape[0]
        ans.append(errorRate)
    print(np.average(ans))
    # 0.372499 when times= 50
    # 0.33     when times=50
  
