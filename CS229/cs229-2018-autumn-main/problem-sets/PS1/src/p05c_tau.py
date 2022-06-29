import matplotlib.pyplot as plt
import numpy as np
import util

from p05b_lwr import LocallyWeightedLinearRegression

tau_values=[3e-2, 5e-2, 1e-1, 5e-1, 1e0, 1e1]
train_path='../data/ds5_train.csv'
valid_path='../data/ds5_valid.csv'
test_path='../data/ds5_test.csv'
pred_path='output/p05c_pred.txt'

def main(tau_values, train_path, valid_path, test_path, pred_path):
    """Problem 5(b): Tune the bandwidth paramater tau for LWR.

    Args:
        tau_values: List of tau values to try.
        train_path: Path to CSV file containing training set.
        valid_path: Path to CSV file containing validation set.
        test_path: Path to CSV file containing test set.
        pred_path: Path to save predictions.
    """
    # Load training set
    x_train, y_train = util.load_dataset(train_path, add_intercept=True)
    x_valid, y_valid = util.load_dataset(valid_path, add_intercept=True)
    x_test, y_test = util.load_dataset(test_path, add_intercept=True)

    # *** START CODE HERE ***
    # Search tau_values for the best tau (lowest MSE on the validation set)
    # Fit a LWR model with the best tau value
    # Run on the test set to get the MSE value
    # Save predictions to pred_path
    # Plot data
    # *** END CODE HERE ***
    
    min_mse = None
    best_tau = None
    
    for tau in tau_values:
        clf = LocallyWeightedLinearRegression(tau=tau)
        clf.fit(x_train,y_train)
        y_pred = clf.predict(x_valid)
        current_mse = np.mean(np.linalg.norm(y_pred-y_valid,ord=2)) 
        if min_mse == None or current_mse < min_mse:
            min_mse = current_mse
            best_tau = tau
        
        ## Plot
        # Plot dataset
        plt.figure()
        plt.plot(x_train[:, -1], y_train, 'bx', linewidth=2)
        plt.plot(x_valid[:,-1], y_pred, 'ro', linewidth=2)
        plt.title("mse:{0:.3f} tau:{1:.3f}".format(current_mse,tau))
        # Add labels and save to disk
        plt.savefig("./output/p05b_{}.png".format(tau))
    
    # Test set with best_tau
    clf = LocallyWeightedLinearRegression(best_tau)
    clf.fit(x_train,y_train)
    y_pred = clf.predict(x_test)
    ## Plot
    # Plot dataset
    plt.figure()
    plt.plot(x_train[:, -1], y_train, 'bx', linewidth=2)
    plt.plot(x_test[:,-1], y_pred ,'ro', linewidth=2)

    # Add labels and save to disk
    plt.savefig("./p05b_test_{}.png".format(best_tau))
   