import numpy as np
import util

from linear_model import LinearModel



         
def main(train_path, eval_path, pred_path):
    """Problem 1(e): Gaussian discriminant analysis (GDA)

    Args:
        train_path: Path to CSV file containing dataset for training.
        eval_path: Path to CSV file containing dataset for evaluation.
        pred_path: Path to save predictions.
    """
    # Load dataset
    x_train, y_train = util.load_dataset(train_path, add_intercept=False)
    #x_train[:,1] = boxcox(x_train[:,1])[0]
  
    # *** START CODE HERE ***
    clf = GDA()
    clf.fit(x_train,y_train)
    
    # Plot the training data and decision boundary  
    print(clf.theta)
    util.plot(x_train, y_train, clf.theta, save_path='./output/p01e_{}.png'.format(pred_path[-5]), correction=clf.constant)
    
    # save the prediction
    x_vali, y_vali = util.load_dataset(eval_path, add_intercept=False)
    y_pred = clf.predict(x_vali)
    np.savetxt(pred_path, y_pred > 0.5, fmt='%d')   
    
    # *** END CODE HERE ***


class GDA(LinearModel):
    """Gaussian Discriminant Analysis.

    Example usage:
        > clf = GDA()
        > clf.fit(x_train, y_train)
        > clf.predict(x_eval)
    """

    def fit(self, x, y):
        """Fit a GDA model to training set given by x and y.

        Args:
            x: Training example inputs. Shape (m, n).
            y: Training example labels. Shape (m,).

        Returns:
            theta: GDA model parameters.
        """
        # *** START CODE HERE ***
        
        ## Maximum Likelihood Estimation
        m,n = x.shape
        self.phi = np.sum(y)/m
        self.mu_1 = np.sum(x[y==1,:],axis=0)/np.sum(y)
        self.mu_0 = np.sum(x[y==0,:],axis=0)/(m-np.sum(y))
        self.covMatrix =((x[y==1,:]-self.mu_1).T.dot((x[y==1,:]-self.mu_1)) + (x[y==0,:]-self.mu_0).T.dot((x[y==0,:]-self.mu_0)))/m      
        self.covMatrix_inv = np.linalg.inv(self.covMatrix)
        self.theta = -0.5*((-self.mu_1).T.dot(self.covMatrix_inv.T)-self.mu_1.T.dot(self.covMatrix_inv)+self.mu_0.T.dot(self.covMatrix_inv.T)+self.mu_0.T.dot(self.covMatrix_inv))
        self.constant = -0.5*self.mu_1.T.dot(self.covMatrix_inv).dot(self.mu_1)+0.5*self.mu_0 .T.dot(self.covMatrix_inv).dot(self.mu_0 )+np.log((1-self.phi)/self.phi)
        self.theta = np.insert(self.theta,0,1)
        # *** END CODE HERE ***

    def predict(self, x):
        """Make a prediction given new inputs x.

        Args:
            x: Inputs of shape (m, n).

        Returns:
            Outputs of shape (m,).
        """
        # *** START CODE HERE ***
        m,n = x.shape       
        return 1/(1+np.exp(x.dot(self.theta[1:])+self.constant))
                  
        # *** END CODE HERE
