from math import sin
from math import pi
from matplotlib import pyplot
# create sequence
length = 100
freq = 5
sequence = [sin(2 * pi * freq * (i/float(length))) for i in range(length)]
# plot sequence
pyplot.plot(sequence)
pyplot.show()