# Advanced Multilayer Perceptrons and Keras  

## Understand Model Behavior During Training By Plotting History
* history = model.fit()的返回object包含了一个叫做history的字典，里头包含了每一次epoch的详细记录(loss与用户需求的metric)
* history.history['xxx']
#
	# Fit the model
	history = model.fit(X, Y, validation_split=0.33, epochs=150, batch_size=10, verbose=0)
	# list all data in history
	print(history.history.keys())
	# summarize history for accuracy
	plt.plot(history.history['accuracy'])
	plt.plot(history.history['val_accuracy'])
	plt.title('model accuracy')
	plt.ylabel('accuracy')
	plt.xlabel('epoch')
	plt.legend(['train', 'test'], loc='upper left')
	plt.show()

## Reduce Overfitting With Dropout Regularization
* Drop out rate is about **0.2~0.5**. 0.2 is a good starting point.
* Use **larger network** to make the model robust against dropout and thus learn indepdendet representations.
* Dropout can be used in **input and hidden layers**.
* After dropout, you may want to **increase learning rate** by a factor of 10 to 100 and use **high momentum** value of 0.9 or 0.99.
* **Constrain the size of network weights**:  
	* kernel_constraint=maxnorm(3): maxnorm(m) will, if the L2-Norm of your weights exceeds m, scale your whole weight matrix by a factor that reduces the norm to m
#
	
	


	def create_model():
		# create model
		model = Sequential()
		model.add(Dropout(0.2, input_shape=(60,)))
		model.add(Dense(60, input_dim=60, activation='relu', kernel_constraint=maxnorm(3)))
		model.add(Dropout(0.2))
		model.add(Dense(30, activation='relu', kernel_constraint=maxnorm(3)))
		model.add(Dropout(0.2))
		model.add(Dense(1, activation='sigmoid'))
		# Compile model
		sgd = SGD(lr=0.1, momentum=0.9)
		model.compile(loss='binary_crossentropy', optimizer=sgd, metrics=['accuracy'])
	return model


## Lift Performance With Learning Rate Schedules
* 一开始使用较大的Learning Rate，从而让decay效果得到体现
* 使用较大的momentem使在learning rate很小时依然在正确方向进行学习
* 尝试不同的learning rate schedule.比如指数下降，或者根据train/test的表现进行调整。  

![Page0](https://github.com/zhukuixi/AshenOne/blob/master/JasonBookSeries/DeepLearningWithPython/img/LearningRateDecayWithTime.png.png)  
PS:注意此处Learning Rate是反复赋值迭代的  

### Time Based Learning Rate Schedule
	# Compile model
	epochs = 50
	learning_rate = 0.1
	decay_rate = learning_rate / epochs
	momentum = 0.8
	sgd = SGD(lr=learning_rate, momentum=momentum, decay=decay_rate, nesterov=False)
	model.compile(loss='binary_crossentropy', optimizer=sgd, metrics=['accuracy'])

### Time Based Learning Rate Schedule
![Page0](https://github.com/zhukuixi/AshenOne/blob/master/JasonBookSeries/DeepLearningWithPython/img/LearningRateDecayWithDrop.png)  
* 自定义learning rate随着epoch下降的函数  
* LearningRateScheduler 与 model.fit中的callbacks
#
	# learning rate schedule
	def step_decay(epoch):
		initial_lrate = 0.1
		drop = 0.5
		epochs_drop = 10.0
		lrate = initial_lrate * math.pow(drop, math.floor((1+epoch)/epochs_drop))
	return lrate

	# create model
	model = Sequential()
	model.add(Dense(34, input_dim=34, activation='relu'))
	model.add(Dense(1, activation='sigmoid'))
	# Compile model
	sgd = SGD(lr=0.0, momentum=0.9)
	model.compile(loss='binary_crossentropy', optimizer=sgd, metrics=['accuracy'])
	# learning schedule callback
	lrate = LearningRateScheduler(step_decay)
	callbacks_list = [lrate]
	# Fit the model
	model.fit(X, Y, validation_split=0.33, epochs=50, batch_size=28, callbacks=callbacks_list,verbose=2)