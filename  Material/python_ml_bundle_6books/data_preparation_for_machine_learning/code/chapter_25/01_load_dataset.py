# load and summarize the dataset
from numpy import loadtxt
# load data
dataset = loadtxt('housing.csv', delimiter=",")
# split into inputs and outputs
X, y = dataset[:, :-1], dataset[:, -1]
# summarize dataset
print(X.shape, y.shape)