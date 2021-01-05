# Load CSV from URL using NumPy
from numpy import loadtxt
from urllib.request import urlopen
url = 'https://goo.gl/bDdBiA'
raw_data = urlopen(url)
dataset = loadtxt(raw_data, delimiter=",")
print(dataset.shape)
