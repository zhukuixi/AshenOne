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
* Using CIFAR-10 dataset (给图像分10类里的一类）

## Project: Predict Sentiment From Movie Reviews
* Learn how to word embedding with Keras
* Build MLP to solve sentiment analysis
* Build one-dimensional CNN to solve sentiment analysis

### Word Embedding
* A recent breakthrough in the field of natural language processing is called word embedding. This is a technique where words are encoded as real-valued vectors in a high dimensional space, where the similarity between words in terms of meaning translates to closeness in the vector space.
* Embedding可以learn on the fly.其实简单说Embedding就是与输入层连接的权重矩阵，输入层看作one-hot-encoding.不同的任务和架构会产生不同的Embedding。流行的Word2Vec是基于CBOW/SkipGram任务和架构的。 已有的Embedding可以拿给其他任务作为输入去使用 :)
* Keras自带**Embedding**(input_dim,output_dim,input_length),  
  也可以理解为**Embedding**(vocabularySize, embeddingVectorLength, DocumentWordCount),  
  这样一来，输出一个2D matrix，其shape为(None,DocumentWordCount,embeddingVectorLength).
* Conv1D()/Conv2D()/ConvXD()，X是几，代表filter顺着头X个dimension方向去做卷积，对应的pool\_size需要指定，其他dimension上的pool_size与输入层对应dimension一致！
*  一个一维filter，如果输入layer是(None,Height,Weight,Channel)。表示是其在Height方向移动，那么这个filter在第一维的pool、_size大小由用户指定，其他维的pool、_size与输入layer的对应维度大小一致。
*  类似地，如果filter设定为Conv2D(64,(5,4)),输入层shape为(None,32,32,3)，则参数个数为5*4*3+1。这个3是对输入层channel维度一致,额外的1为bias term.如果是same padding且stride=1,则输出层shape为(None,32,32,64).


#
	# load the dataset but only keep the top n words, zero the rest
	top_words = 5000
	(X_train, y_train), (X_test, y_test) = imdb.load_data(num_words=top_words)
	# pad dataset to a maximum review length in words
	max_words = 500
	X_train = sequence.pad_sequences(X_train, maxlen=max_words)
	X_test = sequence.pad_sequences(X_test, maxlen=max_words)
	# create the model
	model = Sequential()
	model.add(Embedding(top_words, 32, input_length=max_words))
	model.add(Conv1D(32, 3, padding='same', activation='relu'))
	model.add(MaxPooling1D())
	model.add(Flatten())
	model.add(Dense(250, activation='relu'))
	model.add(Dense(1, activation='sigmoid'))
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	model.summary()
	# Fit the model
	model.fit(X_train, y_train, validation_data=(X_test, y_test), epochs=2, batch_size=128,
	verbose=2)
	# Final evaluation of the model
	scores = model.evaluate(X_test, y_test, verbose=0)