// NOTE:: This example should be run on small clusters (3 nodes or less) - running on 
// larger clusters will post a traceback "index out of range" error due to not enough 
// samples. This is a known issue and will be resolved in a future release.
IMPORT $;
IMPORT Python3 AS Python;
IMPORT GNN;
IMPORT GNN.Tensor;
IMPORT GNN.Internal.Types AS iTypes;
IMPORT GNN.Types;
IMPORT GNN.GNNI;
IMPORT GNN.Internal AS Int;
IMPORT GNN.Utils;
IMPORT Std.System.Thorlib;
imagerecord := $.File_Image.ImageRecordPlus;
myTraindata := $.File_Image.MyTrainData;
myTestdata  := $.File_Image.MyTestData;
Tensdata    := Tensor.R4.TensData;
//create a Tensor of shape [0,60,90,3]: height,width,channels
Channels := 3;
Rws      := 60; 
Cols     := 90;
BCount   := Channels * Rws * Cols;
//independent "X" TRAINING Data
TensData makeTensTrainXDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  Channel := (cnt - 1) % channels + 1;
  Col     := ((cnt - 1) DIV channels) % (cols) + 1;
  RowN    := ((cnt - 1) DIV (channels * cols)) % (Rws) + 1;
  SELF.indexes := [img.recid, RowN, Col, Channel];
  SELF.value   := (REAL)(>UNSIGNED1<)img.image[cnt];//(REAL)(>UNSIGNED1<)
END;
mytensTrainXData := NORMALIZE(mytraindata, BCount, makeTensTrainXDat(LEFT, COUNTER));
OUTPUT(mytensTrainXData,NAMED('TrainIndData'));
OUTPUT(COUNT(mytensTrainXData),NAMED('CntTrainIndData'));
tensTrain := Tensor.R4.MakeTensor([0, Rws, Cols, Channels], mytensTrainXData);
OUTPUT(tensTrain,NAMED('TrainIndTens'));
//dependent ("Y') Training Data:
// Of course, for your Y (dependent training data) you’re going to need to associate some label 
// with each image and then create a tensor of shape:
// [0, 1] 
// and use Utils.ToOneHot() to change that to a one hot encoded tensor of shape [0, numClasses].  
// That is because for neural networks, class variables need to be converted to [isClass0, isClass1, isClass2, …].
// See Tests ClassificationTest.ecl for an example.
TensData makeTensTrainYDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  SELF.indexes := [img.recid, 1];//first element is RECID
  SELF.value   := img.YType;
END;
myYtensTrainData := NORMALIZE(mytraindata, 1, makeTensTrainYDat(LEFT, COUNTER));
OUTPUT(myYTensTrainData,NAMED('DepTrainData'));
OUTPUT(COUNT(myYTensTrainData),NAMED('CntDepTrainData'));
yTrainHot := Utils.ToOneHot(myYtensTrainData, 2);//2 states is dog, not a dog
ytrain := Tensor.R4.MakeTensor([0,2], yTrainHot); //Needs to be from yTrainHot
OUTPUT(yTrain,NAMED('TrainDepTens'));
//Independent Test Data:
TensData makeTensTestXDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  Channel := (cnt - 1) % channels + 1;
  Col     := ((cnt - 1) DIV channels) % (cols) + 1;
  RowN    := ((cnt - 1) DIV (channels * cols)) % (Rws) + 1;
  SELF.indexes := [img.recid, RowN, Col, Channel];
  SELF.value   := (REAL)(>UNSIGNED1<)img.image[cnt];//(REAL)(>UNSIGNED1<)
END;
mytensTestXData := NORMALIZE(myTestData, BCount, makeTensTestXDat(LEFT, COUNTER));
OUTPUT(mytensTestXData,NAMED('TestIndData'));
OUTPUT(COUNT(mytensTestXData),NAMED('CntTestIndData'));
tensTest := Tensor.R4.MakeTensor([0, Rws, Cols, Channels], mytensTestXData);
OUTPUT(tensTest,NAMED('TestIndTens'));
//Dependent Test Data
TensData makeTensTestYDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  SELF.indexes := [img.recid, 1];//first element is RECID
  SELF.value   := img.YType;
END;
myYtensTestData := NORMALIZE(myTestData, 1, makeTensTestYDat(LEFT, COUNTER));
OUTPUT(myYTensTestData,NAMED('TestDepData'));
OUTPUT(COUNT(myYTensTestData),NAMED('CntTestDepData'));
yTestHot := Utils.ToOneHot(myYtensTestData, 2);//2 states is dog, not a dog
ytest    := Tensor.R4.MakeTensor([0,2], yTestHot); //Needs to be from yTrainHot
OUTPUT(yTest,NAMED('TestDepTens'));
// ldef provides the set of Keras layers that form the neural network.  These are
// provided as strings representing the Python layer definitions as would be provided
// to Keras.  Note that the symbol 'tf' is available for use (import tensorflow as tf),
// as is the symbol 'layers' (from tensorflow.keras import layers).
// Recall that in Keras, the input_shape must be present in the first layer.
// Note that this shape is the shape of a single observation.
// ldef := ['''layers.Dense(256, activation='tanh', input_shape=(90,60,3))''',
          // '''layers.Dense(256, activation='relu')''',
          // '''layers.Dense(2, activation=None)'''];
// Muiredach audio settings:
	// model.add(LSTM(50, input_shape=(n_timesteps,n_features)))
	// model.add(Dropout(0.5))
	// model.add(Dense(50, activation='relu'))
	// model.add(Dense(n_outputs, activation='softmax'))
	// model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
					
					
					
ldef :=['''layers.Conv2D(90, (3,3), activation='relu', input_shape=(60,90,3))''',
        '''layers.MaxPooling2D((2,2))''',
        '''layers.Conv2D(90, (3,3), activation='relu')''',
        '''layers.MaxPooling2D((2,2))''',
        '''layers.Conv2D(90, (3,3), activation='relu')''',
        '''layers.Flatten()''',
        '''layers.Dense(3, activation='relu')''',
        '''layers.Dense(2)''']; //2 classification outputs (dog or not a dog)					

// compileDef defines the compile line to use for compiling the defined model.
// Note that 'model.' is implied, and should not be included in the compile line.
// compileDef := '''compile(optimizer=tf.keras.optimizers.SGD(.05),
              // loss=tf.keras.losses.mean_squared_error,
              // metrics=[tf.keras.metrics.mean_squared_error])
              // ''';
//https://www.tensorflow.org/tutorials/images/cnn							
compileDef := '''compile(optimizer=tf.keras.optimizers.Adam(),
                 loss=tf.keras.losses.categorical_crossentropy,
                 metrics=[tf.keras.metrics.Accuracy()])
								   ''';
							
// Note that the order of the GNNI functions is maintained by passing tokens returned from
// one call into the next call that is dependent on it.
// For example, s is returned from GetSession().  It is used as the input to
// DefineModels(...) so
// that DefineModels() cannot execute until GetSession() has completed.
// Likewise, mod, the output from GetSession() is provided as input to Fit().  Fit in turn
// returns a token that is used by GetLoss(), EvaluateMod(), and Predict(),
// which are only dependent on Fit() having completed, and are not order
// dependent on one another.
// GetSession must be called before any other functions
s := GNNI.GetSession();
// DefineModel is dependent on the Session
//   ldef contains the Python definition for each Keras layer
//   compileDef contains the Keras compile statement.
mod := GNNI.DefineModel(s, ldef, compileDef);
// GetWeights returns the initialized weights that have been synchronized across all nodes.
wts := GNNI.GetWeights(mod);
OUTPUT(wts, NAMED('InitWeights'),ALL);
// Fit trains the models, given training X and Y data.  BatchSize is not the Keras batchSize,
// but defines how many records are processed on each node before synchronizing the weights
// mod2 := GNNI.Fit(mod, tensTrain, Ytrain, batchSize := 50, numEpochs := 200, learningRateReduction := 0.5);
mod2 := GNNI.Fit(mod, tensTrain, Ytrain, batchSize := 10, numEpochs := 10);
OUTPUT(mod2, NAMED('mod2'));
// GetLoss returns the average loss for the final training epoch
losses := GNNI.GetLoss(mod2);
// EvaluateMod computes the loss, as well as any other metrics that were defined in the Keras
// compile line.
metrics := GNNI.EvaluateMod(mod2, Tenstest, ytest);
OUTPUT(metrics, NAMED('metrics'));
// Predict computes the neural network output given a set of inputs.
preds := GNNI.Predict(mod2, Tenstest);
// Note that the Tensor is a packed structure of Tensor slices.  GetData()
// extracts the data into a sparse cell-based form -- each record represents
// one Tensor cell.  See Tensor.R4.TensData.
testYDat := Tensor.R4.GetData(yTest);
predDat  := Tensor.R4.GetData(preds);
OUTPUT(SORT(testYDat, indexes), ALL, NAMED('testDat'));
OUTPUT(preds, NAMED('predictions'));
predDatClass := Utils.Probabilities2Class(predDat);
OUTPUT(SORT(predDatClass, value), ALL, NAMED('predDat'));
