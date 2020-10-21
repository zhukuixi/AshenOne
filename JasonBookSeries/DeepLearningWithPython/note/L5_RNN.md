# Recurrent Neural Networks
[人人都能看懂的LSTM](https://zhuanlan.zhihu.com/p/32085405)  
[人人都能看懂的GRU](https://zhuanlan.zhihu.com/p/32481747)  
[LSTM详解](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)  

## Crash Course In Recurrent Neural Networks
* 简单NN也能处理序列input，但是需要一个fixed size **window**。这个窗口大小的设置是死的，无法自适应。
* RNN用BTT(Backpropagation Through Time)来解决训练BP问题
* LSTM包含了gate(Foget/Input/Output)与memory block这些特殊结构。

## 引子： Time Series Prediction with Multilayer Perceptrons
* 连续144个月的航空旅客人数数据。  


### Multilayer Perceptron Regression / Using the Window Method
* Phrase the time series prediction problem as a regression problem (Given **y(t-N)...y(t-1),y(t)**, what is **y(t+1)**? Thus, we convert our single column data into a multiple-column dataset).

#	
	#通过修改look_back来修改Window的大小
	def create_dataset(dataset, look_back=1):
		dataX, dataY = [], []
		for i in range(len(dataset)-look_back-1):
			a = dataset[i:(i+look_back), 0]
			dataX.append(a)
			dataY.append(dataset[i + look_back, 0])
		return numpy.array(dataX), numpy.array(dataY)
	#简单的MLP NN结构
	model = Sequential()
	model.add(Dense(12, input_dim=look_back, activation='relu'))
	model.add(Dense(8, activation='relu'))
	model.add(Dense(1))
	model.compile(loss='mean_squared_error', optimizer='adam')
	model.fit(trainX, trainY, epochs=400, batch_size=2, verbose=2)

### Time Series Prediction with LSTM Recurrent Neural Networks
* LSTM For Regression / Using the Window Method
* LSTM For Regression with Time Steps
* LSTM With Memory Between Batches
* Stacked LSTMs With Memory Between Batches

#### LSTM Network For Regression / Using the Window Method
* LSTM is sensitive to the scale of the input data (specially when using sigmoid or Tanh activation function). It is good to **rescale** the data to the range of 0-to-1.
* LSTM's input data shape is  **[samples,time\_steps,features]**

#	
	# reshape into X=t and Y=t+1
	look_back = 3
	trainX, trainY = create_dataset(train, look_back)
	testX, testY = create_dataset(test, look_back)
	# reshape input to be [samples, time steps, features]
	trainX = numpy.reshape(trainX, (trainX.shape[0], 1, trainX.shape[1]))
	testX = numpy.reshape(testX, (testX.shape[0], 1, testX.shape[1]))
	# create and fit the LSTM network
	model = Sequential()
	model.add(LSTM(4, input_shape=(1, look_back)))
	model.add(Dense(1))
	model.compile(loss='mean_squared_error', optimizer='adam')
	model.fit(trainX, trainY, epochs=100, batch_size=1, verbose=2)

#### LSTM For Regression with Time Steps
* Instead of phrasing the past observations as separate input features, we can use them as
time steps of the one input feature, which is indeed a more accurate framing of the problem!
#
	# reshape input to be [samples, time steps, features]
	trainX = numpy.reshape(trainX, (trainX.shape[0], trainX.shape[1], 1))
	testX = numpy.reshape(testX, (testX.shape[0], testX.shape[1], 1))

#### LSTM With Memory Between Batches
* **[State]** The LSTM network has memory which is capable of remembering across long sequences.Normally, the state within the network is reset after each training batch when fitting the model,as well as each call to model.predict() or model.evaluate(). 正常情况下，每次epoch都自动reset\_states.这样就丧失了记忆。 
* We can gain finer control over when the internal **state** of the LSTM network is cleared in Keras by making the LSTM layer **stateful**. This means that it can build **state** over the entire training sequence and even maintain
that **state** if needed to make predictions.  
**如何操作**:
* LSTM layer指定batch_input_shape=(batch\_size, look\_back, features)以及stateful=True.用这个模型来evaluation and prediction时，必须用一样的batch\_size.例如: model.predict(trainX, batch、_size=batch、_size).
* 手动model.fit(epochs=1，shuffle=False)和model.reset_states().
#
	# reshape input to be [samples, time steps, features]
	trainX = numpy.reshape(trainX, (trainX.shape[0], trainX.shape[1], 1))
	testX = numpy.reshape(testX, (testX.shape[0], testX.shape[1], 1))
	# create and fit the LSTM network
	batch_size = 1
	model = Sequential()
	model.add(LSTM(4, batch_input_shape=(batch_size, look_back, 1), stateful=True))
	model.add(Dense(1))
	model.compile(loss='mean_squared_error', optimizer='adam')
	for i in range(100):
		model.fit(trainX, trainY, epochs=1, batch_size=batch_size, verbose=2, shuffle=False)
		model.reset_states()

#### Stacked LSTMs With Memory Between Batches
* An LSTM layer prior to each subsequent LSTM layer **must return the sequence**. This can be done by setting the return sequences parameter on the layer to True.
*** return_sequences=True**
#
	model.add(LSTM(4, batch\_input_shape=(batch_size, look_back, 1), stateful=True,
	return_sequences=True))
	model.add(LSTM(4, batch\_input_shape=(batch_size, look_back, 1), stateful=True))


## Project: Sequence Classification of Movie Reviews
* Develop LSTM for sequence classification problem
* Reduce overfitting in LSTM by dropout
* Combine LSTM with CNN
* 使用IMDB影评data

#
	# LSTM with dropout layers and dropout within LSTM memory unit
	model = Sequential()
	model.add(Embedding(top_words, embedding_vecor_length, input_length=max_review_length,
	dropout=0.2))
	model.add(LSTM(100, dropout_W=0.2, dropout_U=0.2))
	model.add(Dense(1, activation='sigmoid'))

#
	# LSTM and CNN For Sequence Classification