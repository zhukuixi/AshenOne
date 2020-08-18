# Deep Learning With Python

### My first Keras Neuron Network Model  
1. Network structure
2. Network loss function + optimizer + metrics you want to know
3. Network fitting
4. Network prediction/evaluation  
#

	# define the keras model
	model = Sequential()
	model.add(Dense(12, input_dim=8, activation='relu'))
	model.add(Dense(8, activation='relu'))
	model.add(Dense(1, activation='sigmoid'))
	# compile the keras model
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	# fit the keras model on the dataset
	model.fit(X, y, epochs=150, batch_size=16)
	# evaluate the keras model
	_, accuracy = model.evaluate(X, y)
	# make class predictions with the model  
	predictions = model.predict_classes(X)

### How to evaluate your model
1. 自带的validation set split
2. 使用sklearn的train\_test\_split  
3. 使用sklearn的StratifiedKFold来实现cross-validation

1.Automatic train/validation data split (**validation_split**=0.2)
#
	model.fit(X, Y, validation_split=0.33, epochs=150, batch_size=10)  

2.Manual train/validation data split (**train\_test\_split** and **validation_data**=(x,y))  
#
	X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.33)
	model.fit(X_train, y_train, validation_data=(X_test,y_test), epochs=150, batch_size=10)

3.K-fold cross-validation (**StratifiedKFold**)
#
	kfold = StratifiedKFold(n_splits=10, shuffle=True)
	cvscores = []
	for train, test in kfold.split(X, Y):
		# create model
		model = Sequential()
		model.add(Dense(12, input_dim=8, activation='relu'))
		model.add(Dense(8, activation='relu'))
		model.add(Dense(1, activation='sigmoid'))
		# Compile model
		model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
		# Fit the model
		model.fit(X[train], Y[train], epochs=150, batch_size=10, verbose=0)
		# evaluate the model
		scores = model.evaluate(X[test], Y[test], verbose=0)
		print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))
		cvscores.append(scores[1] * 100)
	print("%.2f%% (+/- %.2f%%)" % (numpy.mean(cvscores), numpy.std(cvscores)))

### keras + sklearn = Happy!
1. 整合Keras进入sklearn (可以见到整合进来后，进入sklearn体系，模型evaluation变得只需要一行cross\_val\_score ^^)
2. 整合后用GridSearch调整超参

1.Warp keras model into sklearn (**KerasClassifier/KerasRegressor** + **build_fn** + **a function for network construction**)  

* step1: def **create_model**(): model = Sequential() ..
* step2: model = **KerasClassifier**(**build_fn=create_model**, epochs=150, batch_size=10, verbose=0)  
#
	

	from keras.wrappers.scikit_learn import KerasClassifier
	# Function to create model, required for KerasClassifier
	def create_model():
		# create model
		model = Sequential()
		model.add(Dense(12, input_dim=8, activation='relu'))
		model.add(Dense(8, activation='relu'))
		model.add(Dense(1, activation='sigmoid'))
		# Compile model
		model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model
	# 这里传入了函数名称create_model到build_fn，还传入了fit时所需的epoch,battch_size等参数）
	model = KerasClassifier(build_fn=create_model, epochs=150, batch_size=10, verbose=0)
	# evaluate using 10-fold cross validation
	kfold = StratifiedKFold(n_splits=10, shuffle=True)
	results = cross_val_score(model, X, Y, cv=kfold)
	print(results.mean())

2.Tune Deep Learning Model Hyperparameter with sklearn's **Grid Search**  

* step1: def **create_model**(optimizer='rmsprop', init='glorot_uniform'):
* step2: **param_grid** = dict(optimizer=optimizers, epochs=epochs, batch_size=batches, init=inits)
* step3: GridSearchCV(estimator=model, param_grid=**param_grid**, cv=3)

#
	#修改create_model所接纳的参数，让其能接受想修改的超参数
	def create_model(optimizer='rmsprop', init='glorot_uniform')：
		....
	# create model
	model = KerasClassifier(build_fn=create_model, verbose=0)
	# grid search epochs, batch size and optimizer (用字典把超参名字和想搜索的区间定义好）
	optimizers = ['rmsprop', 'adam']
	inits = ['glorot_uniform', 'normal', 'uniform']
	epochs = [50, 100, 150]
	batches = [5, 10, 20]
	param_grid = dict(optimizer=optimizers, epochs=epochs, batch_size=batches, init=inits)
	grid = GridSearchCV(estimator=model, param_grid=param_grid, cv=3)
	grid_result = grid.fit(X, Y)
	# summarize results
	print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))

3.Improve the model

* Data preprocess  
* Tuning Layers and Neurons in The Model

 **Data Preprocess (Standardization)**. 巧用Pipeline让数据预处理和CV一体化.不是对X整体预处理，而是每次CV，scaler去单独fit X\_train,transform X\_vali，避免了data leak.
		# 

			from sklearn.pipeline import Pipeline
			estimators = []
			estimators.append(('standardize', StandardScaler()))
			estimators.append(('mlp', KerasClassifier(build_fn=create_baseline, epochs=100,
			batch_size=5, verbose=0)))
			#由此一来，Pipeline替代了estimator在cross_val_score的位置
			pipeline = Pipeline(estimators)
			kfold = StratifiedKFold(n_splits=10, shuffle=True)
			results = cross_val_score(pipeline, X, encoded_Y, cv=kfold)
			print("Baseline: %.2f%% (%.2f%%)" % (results.mean()*100, results.std()*100))
