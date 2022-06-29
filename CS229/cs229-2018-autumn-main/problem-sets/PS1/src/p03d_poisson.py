import numpy as np
import util

from linear_model import LinearModel

import matplotlib.pyplot as plt

        
def main(lr, train_path, eval_path, pred_path):
    """Problem 3(d): Poisson regression with gradient ascent.

    Args:
        lr: Learning rate for gradient ascent.
        train_path: Path to CSV file containing dataset for training.
        eval_path: Path to CSV file containing dataset for evaluation.
        pred_path: Path to save predictions.
    """
    # Load training set
    x_train, y_train = util.load_dataset(train_path, add_intercept=True)
    x_valid, y_valid = util.load_dataset(eval_path, add_intercept=True)

    # *** START CODE HERE ***
    # Fit a Poisson Regression model
    # Run on the validation set, and use np.savetxt to save outputs to pred_path
    clf = PoissonRegression(step_size = lr)
    clf.fit(x_train,y_train)
    y_predict = clf.predict(x_valid)
    plt.scatter(x=y_predict,y=y_valid)
    #scipy.stats.pearsonr(y_predict,y_valid)
    np.savetxt(pred_path,y_predict)
    
    
    # *** END CODE HERE ***


class PoissonRegression(LinearModel):
    """Poisson Regression.

    Example usage:
        > clf = PoissonRegression(step_size=lr)
        > clf.fit(x_train, y_train)
        > clf.predict(x_eval)
    """

    def fit(self, x, y):
        """Run gradient ascent to maximize likelihood for Poisson regression.

        Args:
            x: Training example inputs. Shape (m, n).
            y: Training example labels. Shape (m,).
        """
        # *** START CODE HERE ***
        m,n = x.shape
        self.theta = np.zeros(n)
       
        # SGD
 
        while True:            
            theta_change = self.step_size*x.T.dot(y-np.exp(x.dot(self.theta)))/m
            self.theta += theta_change
            if np.linalg.norm(theta_change,ord=1)<self.eps:
                break
            
        
        # *** END CODE HERE ***

    def predict(self, x):
        """Make a prediction given inputs x.

        Args:
            x: Inputs of shape (m, n).

        Returns:
            Floating-point prediction for each input, shape (m,).
        """
        # *** START CODE HERE ***
        return np.exp(x.dot(self.theta))
        # *** END CODE HERE ***
