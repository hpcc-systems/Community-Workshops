IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;

//Training and Test data
XTrain := $.Convert02_MI.myIndTrainDataNF;
YTrain := $.Convert02_MI.myDepTrainDataNF;
XTest  := $.Convert02_MI.myIndTestDataNF;
YTest  := $.Convert02_MI.myDepTestDataNF;

//Train Boosted Forest model on Property data
myLearner    := LT.BoostedRegForest(,,,,,[1]); // Make the zipcode field a nominal (categorical) field.
myModel      := myLearner.GetModel(XTrain,YTrain);

//Test Boosted Forest model on Property data
MyPredict := myLearner.Predict(myModel,XTest);
OUTPUT(MyPredict, NAMED('PredictedValues'));//workitem,uniqueid,field number, dependent value

//Assess Boosted Forest model on Property data
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(MyPredict,YTest);
OUTPUT(assessmentR2, NAMED('Accuracy'));