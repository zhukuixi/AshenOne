# Convolutional Neural Networks

## Crash Course in CNN
1. Convolutiona Layers (Filters+Feature Maps)
2. Pooling Layers
3. Fully-Connected Layers

**CNN Keras example for MNIST:**

#
	def larger_model():
	# create model
	model = Sequential()
	model.add(Conv2D(30, (5, 5), input_shape=(28, 28, 1), activation='relu'))
	model.add(MaxPooling2D())
	model.add(Conv2D(15, (3, 3), activation='relu'))
	model.add(MaxPooling2D())
	model.add(Dropout(0.2))
	model.add(Flatten())
	model.add(Dense(128, activation='relu'))
	model.add(Dense(50, activation='relu'))
	model.add(Dense(num_classes, activation='softmax'))
	# Compile model
	model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

## Improve Model Performance With Image Augmentation
* Keras Image Augmentation API (ImageDataGenerator class)
	* Sample-wise(standardize pixel within each image respectively),Feature-wise(for a pixel,standardize it across whole dataset) standardization.
	* ZCA whitening.
	* Random rotation, shifts, shear and flips.
	* Dimension reordering.
	* Save augmented images to disk
* Tips:
	* Review raw data to gain insights of to augment data in what way
	* Review augmented data to gain insights of to augment data in what way
	* Try out different augmented scheme

ImageDataGenerator产生的实例本身是一个iterator,fit后，使用flow来产生新处理的图像。
#
	
	datagen = ImageDataGenerator()
	datagen.fit(train)
	X_batch, y_batch = datagen.flow(train, train, batch_size=32)
	fit_generator(datagen, samples_per_epoch=len(train), epochs=100)

### Feature Standardization
	
	# define data preparation
	datagen = ImageDataGenerator(featurewise_center=True, featurewise_std_normalization=True)
	# fit parameters from data
	datagen.fit(X_train)
	# configure batch size and retrieve one batch of images
	for X_batch, y_batch in datagen.flow(X_train, y_train, batch_size=9):
		# create a grid of 3x3 images
		for i in range(0, 9):
			pyplot.subplot(330 + 1 + i)
			pyplot.imshow(X_batch[i].reshape(28, 28), cmap=pyplot.get_cmap('gray'))
		# show the plot
		pyplot.show()
		break

### ZCA Whitening
	datagen = ImageDataGenerator(zca_whitening=True)
### Random Rotations
	# 最多旋转90°的随机旋转
	datagen = ImageDataGenerator(rotation_range=90) 
### Random Shifts
	datagen = ImageDataGenerator(width_shift_range=0.2, height_shift_range=0.3)
### Random Flips （镜像对称）
	datagen = ImageDataGenerator(horizontal_flip=True, vertical_flip=True)
### Saving Augmented Images to File

	# define data preparation
	datagen = ImageDataGenerator()
	# fit parameters from data
	datagen.fit(X_train)
	# configure batch size and retrieve one batch of images
	os.makedirs('images')
	for X_batch, y_batch in datagen.flow(X_train, y_train, batch_size=9, save_to_dir='images',save_prefix='aug', save_format='png'):
		next

## Project Object Recognition in Photographs
* Using CIFAR-10 dataset