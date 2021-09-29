IMPORT LogisticRegression as LR;
IMPORT ML_Core;
IMPORT $;
//Training and Test data
XTrain := $.Convert02.myIndTrainDataNF;
YTrain := $.Convert02.myDepTrainDataNF;
XTest  := $.Convert02.myIndTestDataNF;
YTest  := $.Convert02.myDepTestDataNF;
//Train Logistic Regression Model on Banking data
myLearner := LR.BinomialLogisticRegression();
myModel   := myLearner.getModel(XTrain, YTrain);
	 
//Test Logistic Regression Model on Banking data
MyPredict := myLearner.Classify(myModel, XTest);
OUTPUT(MyPredict, NAMED('PredictedValues'));
//Assess Logistic Regression model on Banking data
MyConfMatrix := ML_Core.Analysis.Classification.ConfusionMatrix(Ytest,MyPredict);
OUTPUT(MyConfMatrix, NAMED('ConfusionMatrix'));
MyConfAccy := LR.BinomialConfusion(MyConfMatrix);
OUTPUT(MyConfAccy, NAMED('ConfusionAccuracy'));	 
	 
//Utilize AIC (Akaike Information Criterion) for model optimization
MyBeta := LR.ExtractBeta(myModel);
OUTPUT(MyBeta, NAMED('BetaValues'));
MyScores := LR.LogitScore(MyBeta,Xtest);
OUTPUT(MyScores , NAMED('ScoreValues'));
MyDeviance := LR.Deviance_Detail(YTest,MyScores);
OUTPUT(MyDeviance, NAMED('DevianceValues'));
MyAIC := LR.Model_Deviance(MyDeviance,MyBeta);
OUTPUT(MyAIC, NAMED('AIC'));
   
   
   

