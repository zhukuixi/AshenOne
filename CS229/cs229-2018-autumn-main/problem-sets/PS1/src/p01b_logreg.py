import numpy as np
import util
from linear_model import LinearModel


 
def main(train_path, eval_path, pred_path):
    """Problem 1(b): Logistic regression with Newton's Method.

    Args:
        train_path: Path to CSV file containing dataset for training.
        eval_path: Path to CSV file containing dataset for evaluation.
        pred_path: Path to save predictions.
    """
    x_train, y_train = util.load_dataset(train_path, add_intercept=True)
    
    # *** START CODE HERE ***
    
    # Train the logsitic regression model
    clf = LogisticRegression()
    clf.fit(x_train,y_train)
    
    # Plot the training data and decision boundary   
    util.plot(x_train, y_train, clf.theta, save_path='./output/p01b_{}.png'.format(pred_path[-5]), correction=1.0)
    
    # save the prediction
    x_vali, y_vali = util.load_dataset(eval_path, add_intercept=True)
    y_pred = clf.predict(x_vali)
    np.savetxt(pred_path, y_pred > 0.5, fmt='%d')  
    
    # *** END CODE HERE ***


class LogisticRegression(LinearModel):
    """Logistic regression with Newton's Method as the solver.

    Example usage:
        > clf = LogisticRegression()
        > clf.fit(x_train, y_train)
        > clf.predict(x_eval)
    """    

    def fit(self, x, y):
        """Run Newton's Method to minimize J(theta) for logistic regression.

        Args:
            x: Training example inputs. Shape (m, n).
            y: Training example labels. Shape (m,).
        """
        
    
        # *** START CODE HERE ***
        m,n = x.shape
        self.theta = np.zeros(n)
        
        while True:
           #Compute the gradient and hessian
           h_x = 1 / (1 + np.exp(-1*x.dot(self.theta)))                   
           gradient =  x.T.dot(h_x-y)/m
           hessian = x.T.dot(np.diag(h_x * (1-h_x))).dot(x)   
           
           # Compute the change of theta
           theta_change = np.linalg.inv(hessian).dot(gradient)           
           self.theta -= theta_change
           if np.linalg.norm(theta_change,ord=1) < self.eps:
               break 
           
        # *** END CODE HERE ***
        
        

    def predict(self, x):
        """Make a prediction given new inputs x.

        Args:
            x: Inputs of shape (m, n).

        Returns:
            Outputs of shape (m,).
        """
        # *** START CODE HERE ***
        return 1 / (1 + np.exp(-1*x.dot(self.theta)))                   

        # *** END CODE HERE ***
        
