IMPORT $;
IMPORT ML_Core;
IMPORT KMeans;

//Training Data
TrainAttr := $.Convert02.myTrainAttrNF;

//Initial centroids
//Remember to update the values in the SET according to your previous DBSCAN run
Centroids := TrainAttr(id IN [3,116,591,2036,2299]);

//Setup the model parameters and the model
Max_iterations := 20;
Tolerance := 0;
Pre_Model := KMeans.KMeans(Max_iterations, Tolerance);

//Train K-means model on Housing data
MyModel := Pre_Model.Fit(TrainAttr,Centroids);

//Number of iterations
Iterations := KMeans.KMeans().Iterations(MyModel);
OUTPUT(Iterations,NAMED('Iterations'));

//Coordinates of final centroids
Centers := KMeans.KMeans().Centers(MyModel);
OUTPUT(Centers,NAMED('Centers'));

//Closest clusters for each record
Labels := KMeans.KMeans().Labels(MyModel);
OUTPUT(Labels,NAMED('Labels'));

// Calculate the Silhouette Coefficient for model optimization
SSS := ML_Core.Analysis.Clustering.SilhouetteScore(TrainAttr,Labels);
OUTPUT(sss,NAMED('SS_Analysis'));

//Predict the cluster index of the new samples
NewSample := DATASET([{1,1,1,-0.035},
                      {1,1,2,-0.198},
                      {1,1,3,-0.147},
                      {1,1,4,-0.343},
                      {1,1,5,0.134},
                      {1,1,6,-0.132},
                      {1,1,7,-0.401},
                      {1,1,8,0.343},
                      {1,1,9,-1.031},
                      {1,1,10,-0.071},
                      {1,1,11,-0.156},
                      {1,1,12,-0.121},
                      {1,1,13,-0.084}],ML_Core.Types.NumericField);
LabelID := KMeans.KMeans().Predict(MyModel,NewSample);
OUTPUT(LabelID,NAMED('LabelID'));