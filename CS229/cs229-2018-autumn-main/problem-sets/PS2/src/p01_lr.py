# Important note: you do not have to modify this file for your homework.

import util
import numpy as np
import seaborn as sns

def calc_grad(X, Y, theta):
    """Compute the gradient of the loss with respect to theta."""
    m, n = X.shape

    margins = Y * X.dot(theta)
    probs = 1. / (1 + np.exp(margins))
    grad = -(1./m) * (X.T.dot(probs * Y))
    
    #margins = -X.dot(theta)
    #probs = 1. / (1 + np.exp(margins))
    #grad = (1./m) * (X.T.dot(probs-(1+Y)/2))
      

    return grad


def logistic_regression(X, Y):
    """Train a logistic regression model."""
    m, n = X.shape
    theta = np.zeros(n)
    #theta = np.random.randn(n)
    learning_rate = 10

    i = 0
    thetaStore = theta
    while True:
        i += 1
        prev_theta = theta
        grad = calc_grad(X, Y, theta)
        theta = theta - learning_rate * grad
        if i % 10000 == 0:
            print(theta)
            thetaStore = np.vstack([thetaStore, theta])
            sns.lineplot(x=range(thetaStore.shape[0]),y=thetaStore[:,0],color="r")
            sns.lineplot(x=range(thetaStore.shape[0]),y=thetaStore[:,1],color="g")
            sns.lineplot(x=range(thetaStore.shape[0]),y=thetaStore[:,2],color="b")       
         
            # prediction diagnosis
            margin  = -X.dot(theta)
            predict = 1/(1+np.exp(margin))
            predict_label = [1 if e>0.5 else -1 for e in predict]    
            accuracyResult = sum(Y==predict_label)/len(Y)
            print("accuracy: %f "%(accuracyResult))
        
            # draw error
            
            print('Finished %d iterations' % i)
        if np.linalg.norm(prev_theta - theta) < 1e-15:

            print('Converged in %d iterations' % i)
            break
        
        
    return 


def main():
    print('==== Training model on data set A ====')
    Xa, Ya = util.load_csv('../data/ds1_a.csv', add_intercept=True)
    logistic_regression(Xa, Ya)

    print('\n==== Training model on data set B ====')
    Xb, Yb = util.load_csv('../data/ds1_b.csv', add_intercept=True)
    a=logistic_regression(Xb, Yb)


if __name__ == '__main__':
    main()
    
AA




