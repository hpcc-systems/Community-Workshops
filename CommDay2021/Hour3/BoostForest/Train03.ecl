IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;

//Training and Test data
XTrain := $.Convert02.myIndTrainDataNF;
YTrain := $.Convert02.myDepTrainDataNF;
XTest  := $.Convert02.myIndTestDataNF;
YTest  := $.Convert02.myDepTestDataNF;

//Train Boosted Forest model on Property data
myLearner    := LT.BoostedRegForest(,,,,,[1]); // Make the zipcode field a nominal (categorical) field.
myModel      := myLearner.GetModel(XTrain,YTrain);

//Test Boosted Forest model on Property data
MyPredict := myLearner.Predict(myModel,XTest);
OUTPUT(MyPredict, NAMED('PredictedValues'));//workitem,uniqueid,field number, dependent value

//Assess Boosted Forest model on Property data
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(MyPredict,YTest);
OUTPUT(assessmentR2, NAMED('Accuracy'));

