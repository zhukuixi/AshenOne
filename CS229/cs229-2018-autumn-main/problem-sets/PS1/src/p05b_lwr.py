import matplotlib.pyplot as plt
import numpy as np
import util

from linear_model import LinearModel



         

def main(tau, train_path, eval_path):
    """Problem 5(b): Locally weighted regression (LWR)

    Args:
        tau: Bandwidth parameter for LWR.
        train_path: Path to CSV file containing dataset for training.
        eval_path: Path to CSV file containing dataset for evaluation.
    """
    # Load training set
    x_train, y_train = util.load_dataset(train_path, add_intercept=True)
    x_valid, y_valid = util.load_dataset(eval_path, add_intercept=True)

    # *** START CODE HERE ***
    # Fit a LWR model
    # Get MSE value on the validation set
    # Plot validation predictions on top of training set
    # No need to save predictions
    # Plot data
    
    clf = LocallyWeightedLinearRegression(tau=0.5)
    clf.fit(x_train,y_train)
    y_pred = clf.predict(x_valid)
    mse = np.mean(np.linalg.norm(y_pred-y_valid,ord=2))
    
    ## Plot
    
    # Plot dataset
    plt.figure()
    plt.plot(x_train[:, -1], y_train, 'bx', linewidth=2)
    plt.plot(x_valid[:,-1], y_pred, 'ro', linewidth=2)

    # Add labels and save to disk
    plt.savefig("p05b.png")
    
    # *** END CODE HERE ***


class LocallyWeightedLinearRegression(LinearModel):
    """Locally Weighted Regression (LWR).

    Example usage:
        > clf = LocallyWeightedLinearRegression(tau)
        > clf.fit(x_train, y_train)
        > clf.predict(x_eval)
    """

    def __init__(self, tau):
        super(LocallyWeightedLinearRegression, self).__init__()
        self.tau = tau
        self.x = None
        self.y = None

    def fit(self, x, y):
        """Fit LWR by saving the training set.

        """
        # *** START CODE HERE ***
        self.x = x
        self.y = y
        
        # *** END CODE HERE ***

    def predict(self, x):
        """Make predictions given inputs x.

        Args:
            x: Inputs of shape (m, n).

        Returns:
            Outputs of shape (m,).
        """
        # *** START CODE HERE ***
        m,n = x.shape
        y_pred = np.zeros(m)
        for i in np.arange(m):
            currentPredictionData = x[i,:].reshape(1,-1)
            distance = np.exp(-1*np.linalg.norm(self.x-currentPredictionData,ord=2,axis=1)/(2*self.tau))
            w = np.diag(distance/2)
            theta = np.linalg.inv(self.x.T.dot(w).dot(self.x)).dot(self.x.T.dot(w)).dot(self.y)
            y_pred[i] = currentPredictionData.dot(theta)
            
        return y_pred    
        # *** END CODE HERE ***
