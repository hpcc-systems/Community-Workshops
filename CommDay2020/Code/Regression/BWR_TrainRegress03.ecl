IMPORT LearningTrees AS LT;
IMPORT ML_Core;
IMPORT $;
// RegressionForest(UNSIGNED numTrees=100, UNSIGNED featuresPerNode=0, UNSIGNED maxDepth=100, SET OF UNSIGNED nominalFields=[])
// We use the default configuration parameters.  That usually works fine.
myLearnerR    := LT.RegressionForest(); 
myModelR      := myLearnerR.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);
predictedDeps := myLearnerR.Predict(myModelR, $.Convert02.myIndTestDataNF);
OUTPUT(predictedDeps);//workitem,uniqueid,field number, dependent value
assessmentR   := ML_Core.Analysis.Regression.Accuracy(predictedDeps, $.Convert02.myDepTestDataNF);
OUTPUT(assessmentR);
// To test new data:
// predictedValues := myLearnerR.Predict(myModelR, myNewIndData);
//improve the testing
myLearnerR2    := LT.RegressionForest(,,,[1]); // Make the zipcode field a nominal (categorical) field.
myModelR2      := myLearnerR2.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);
predictedDeps2 := myLearnerR2.Predict(myModelR2, $.Convert02.myIndTestDataNF);
OUTPUT(predictedDeps2);//workitem,uniqueid,field number, dependent value
assessmentR2   := ML_Core.Analysis.Regression.Accuracy(predictedDeps2, $.Convert02.myDepTestDataNF);
OUTPUT(assessmentR2);
