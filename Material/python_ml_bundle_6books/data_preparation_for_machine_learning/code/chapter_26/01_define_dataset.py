# example of creating a test dataset and splitting it into train and test sets
from sklearn.datasets import make_blobs
from sklearn.model_selection import train_test_split
# prepare dataset
X, y = make_blobs(n_samples=100, centers=2, n_features=2, random_state=1)
# split data into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=1)
# summarize the scale of each input variable
for i in range(X_test.shape[1]):
	print('>%d, train: min=%.3f, max=%.3f, test: min=%.3f, max=%.3f' %
		(i, X_train[:, i].min(), X_train[:, i].max(),
			X_test[:, i].min(), X_test[:, i].max()))