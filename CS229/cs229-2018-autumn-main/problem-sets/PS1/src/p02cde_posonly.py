import numpy as np
import util

from p01b_logreg import LogisticRegression

# Character to replace with sub-problem letter in plot_path/pred_path
WILDCARD = 'X'

train_path='../data/ds3_train.csv'
valid_path='../data/ds3_valid.csv'
test_path='../data/ds3_test.csv'
pred_path='output/p02X_pred.txt'
        
        
def main(train_path, valid_path, test_path, pred_path):
    """Problem 2: Logistic regression for incomplete, positive-only labels.

    Run under the following conditions:
        1. on y-labels,
        2. on l-labels,
        3. on l-labels with correction factor alpha.

    Args:
        train_path: Path to CSV file containing training set.
        valid_path: Path to CSV file containing validation set.
        test_path: Path to CSV file containing test set.
        pred_path: Path to save predictions.
    """
    pred_path_c = pred_path.replace(WILDCARD, 'c')
    pred_path_d = pred_path.replace(WILDCARD, 'd')
    pred_path_e = pred_path.replace(WILDCARD, 'e')

    # *** START CODE HERE ***
    # Part (c): Train and test on true labels
    # Make sure to save outputs to pred_path_c
     
    # Load in data
    data_train = np.loadtxt(train_path, delimiter=',', skiprows=1)
    data_test = np.loadtxt(test_path, delimiter=',', skiprows=1)
    data_valid = np.loadtxt(valid_path, delimiter=',', skiprows=1)
    
    # Split the data - train
    x_train = data_train[:,1:3]
    x_test = data_test[:,1:3]
    x_valid = data_valid[:,1:3]
    
    # Add intercept
    x_train = np.insert(x_train,0,1,axis=1)
    x_test = np.insert(x_test,0,1,axis=1)
    x_valid = np.insert(x_valid,0,1,axis=1)
    
    # Split the data - t
    t_train = data_train[:,0]
    t_test = data_test[:,0]
    t_valid = data_valid[:,0]
    
    # Split the data - y
    y_train = data_train[:,-1]
    y_test = data_test[:,-1]
    y_valid = data_valid[:,-1]

    # Classfication
    clf1 = LogisticRegression()
    clf1.fit(x_train,t_train)
    y_pred_clf1 = clf1.predict(x_test)
    np.savetxt(pred_path_c, y_pred_clf1 > 0.5, fmt='%d') 
    
    # Part (d): Train on y-labels and test on true labels
    # Make sure to save outputs to pred_path_d
    clf2 = LogisticRegression()
    clf2.fit(x_train,y_train)
    y_pred_clf2 = clf2.predict(x_test)
    np.savetxt(pred_path_d, y_pred_clf2 > 0.5, fmt='%d') 
    
    # Part (e): Apply correction factor using validation set and test on true labels
    # Plot and use np.savetxt to save outputs to pred_path_e
    valid_prediciton = clf2.predict(x_valid)
    alpha = np.mean(valid_prediciton[y_valid==1])
    
    y_pred_clf2_corrected = y_pred_clf2/alpha
    np.savetxt(pred_path_e, y_pred_clf2_corrected > 0.5, fmt='%d') 

    util.plot(x_test, t_test, clf1.theta, save_path='./output/p02c.png', correction=1)
    util.plot(x_test, t_test, clf2.theta, save_path='./output/p02d.png', correction=1)
    util.plot(x_test, t_test, clf2.theta, save_path='./output/p02e.png', correction=1+np.log(2/alpha-1)/clf2.theta[0])
    
    # *** END CODER HERE
    
    

