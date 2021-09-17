IMPORT LinearRegression AS LR;
IMPORT ML_Core;
IMPORT $;

//Training and Test data
XTrain := $.Convert02.myIndTrainDataNF;
YTrain := $.Convert02.myDepTrainDataNF;
XTest  := $.Convert02.myIndTestDataNF;
YTest  := $.Convert02.myDepTestDataNF;

//Train Linear Regression model on Property data
myLearner := LR.OLS(XTrain,YTrain);
MyModel   := myLearner.GetModel;
Betas     := myLearner.Betas();
OUTPUT(Betas,NAMED('Betas'));

//Test Linear Regression model on Property data
MyPredict := myLearner.Predict(XTest,MyModel);
OUTPUT(MyPredict,NAMED('PredictedValues'));

//Assess Linear Regression model on Property data
//R Squared - R Squared generally varies between 0 and 1, 
//with 1 indicating an exact linear fit, and 0 indicating that a
//linear fit will have no predictive power
Rsq := myLearner.RSquared;
OUTPUT(Rsq,NAMED('RSq'));
ARsq := myLearner.AdjRSquared;
OUTPUT(ARsq,NAMED('AdjRSq'));

//Utilize p-values for model optimization
TVal := myLearner.TStat;
OUTPUT(TVal,NAMED('TStat'));
pValue := myLearner.pval;
OUTPUT(pValue,NAMED('pvalues'));
CIVal := myLearner.ConfInt(95);
OUTPUT(CIVal,NAMED('ConfInt'));

