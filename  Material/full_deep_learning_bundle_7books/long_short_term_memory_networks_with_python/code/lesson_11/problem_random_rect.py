from random import random

# generate a rectangle with random width and height
def random_rectangle():
	width, height = random(), random()
	points = list()
	# bottom left
	points.append([0.0, 0.0])
	# bottom right
	points.append([width, 0.0])
	# top right
	points.append([width, height])
	# top left
	points.append([0.0, height])
	return points

rect = random_rectangle()
print(rect)