IMPORT $;
IMPORT ML_Core;
IMPORT DBSCAN;

//Training Data
TrainAttr := $.Convert02.myTrainAttrNF;

//Train the DBScan model on Housing data - results might vary depending on your training sample
// MyModel :=  DBSCAN.DBSCAN().Fit(TrainAttr); //SS: (-0.63), 22 clusters 4950 outliers
// MyModel :=  DBSCAN.DBSCAN(1,20).Fit(TrainAttr); //SS: (0.41), 9 clusters 335 outliers
// MyModel :=  DBSCAN.DBSCAN(10,20).Fit(TrainAttr); //SS: (0.90), 1 cluster 34 outliers
MYModel :=  DBSCAN.DBSCAN(4,4).Fit(TrainAttr); //SS: (0.62), 5 clusters 39 outliers 
OUTPUT(MyModel,ALL,NAMED('Model'));
OUTPUT(MyModel(label=0),NAMED('Outliers'));

//Number of clusters 
NumClusters := DBSCAN.DBSCAN().Num_Clusters(MyModel);
OUTPUT(NumClusters,NAMED('NumClusters'));
 
//Number of outliers
NumOutliers :=  DBSCAN.DBSCAN().Num_Outliers(MyModel);
OUTPUT(NumOutliers,NAMED('NumOutliers'));

//Silhouette Coefficient for model optimization
/* The Silhouette Coefficient is calculated using the mean intra-cluster distance ( a ) 
   and the mean nearest-cluster distance ( b ) for each sample. ... 
   To obtain the values for each sample, use silhouette_samples . 
   The best value is 1 and the worst value is -1. Values near 0 indicate overlapping clusters
*/
SSS := ML_Core.Analysis.Clustering.SilhouetteScore(TrainAttr,MyModel);
OUTPUT(sss,NAMED('Analysis'));