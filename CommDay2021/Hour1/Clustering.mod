//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.BWR_ViewPrepData
IMPORT $,STD;

//Browse raw input data
OUTPUT($.File_Housing.File,NAMED('Housing'));
COUNT($.File_Housing.File);

// Profiling the raw data
// OUTPUT(STD.DataPatterns.Benford($.File_Housing.File));
// OUTPUT(STD.DataPatterns.Profile($.File_Housing.File));

// Browse formatted input data
// OUTPUT($.Prep01.myDataE,NAMED('FormattedHousing'));
// COUNT($.Prep01.myDataE);

//Browse train data
// OUTPUT($.Prep01.myTrainData,NAMED('MyTrainData'));

//Browse standardized and converted train data
// OUTPUT($.Convert02.myTrainAttrNF,NAMED('TrainAttributesNF'));




//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.Convert02
IMPORT $;
IMPORT ML_Core;
myTrainData := $.Prep01.myTrainData;

//Add a sequential ID
ML_Core.AppendSeqId(myTrainData,recid,myTrainIDData); 
// OUTPUT(myTrainIDData, NAMED('TrainDataID'));  //Uncomment to spot the sequential recid field created

//Numeric Field Matrix conversion
ML_Core.ToField(myTrainIDData, myTrainIDDataNF);
// OUTPUT(myTrainIDDataNF, NAMED('TrainDataNF'));  //Uncomment to spot the Numeric Field Matrix conversion

//* <-- Delete the first forward slash (/) just before the asterisk (*) to comment out the entire MODULE
EXPORT Convert02 := MODULE
  //Calculate basic statistics for the field values
  EXPORT myAggs := ML_Core.FieldAggregates(myTrainIDDataNF).simple;
  
	//Function to standardize the field values 
  fSTD(REAL fieldval, UNSIGNED varnum):= (fieldval-myAggs(number=varnum)[1].mean)/myAggs(number=varnum)[1].sd;

  RECORDOF(myTrainIDData) ML_STD(myTrainIDData Le) := TRANSFORM
	  SELF.NumberOfFronts        := fSTD(Le.NumberOfFronts,1);
	  SELF.LandSquareFootage     := fSTD(Le.LandSquareFootage,2);
	  SELF.LivingSquareFootage   := fSTD(Le.LivingSquareFootage,3);
	  SELF.BuildingSquareFootage := fSTD(Le.BuildingSquareFootage,4);
	  SELF.YearBuilt             := fSTD(Le.YearBuilt,5);
		SELF.NumberOfFloors        := fSTD(Le.NumberOfFloors,6);
		SELF.FrontLinearFeet       := fSTD(Le.FrontLinearFeet,7);
		SELF.CityZone              := fSTD(Le.CityZone,8);
		SELF.CondominiumAdj        := fSTD(Le.CondominiumAdj,9);
		SELF.LandExcess            := fSTD(Le.LandExcess,10);
		SELF.BuildingValue         := fSTD(Le.BuildingValue,11);
		SELF.LandValue             := fSTD(Le.LandValue,12);
		SELF.ExcessValue           := fSTD(Le.ExcessValue,13);
    SELF                       := Le;
   END;
	 
  //Project for value standardization
  EXPORT myTrainDataSTD := PROJECT(myTrainIDData,ML_STD(LEFT));

  //Numeric Field Matrix conversion for standardized values
	ML_Core.ToField(myTrainDataSTD,myTrainDataSTDNF);
	
  //We have 13 numeric attributes for clustering  
	EXPORT myTrainAttrNF := myTrainDataSTDNF(number < 14);

END;
// */
//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.File_Housing
// The dataset we are using contains publicly available information from properties of the City of São Paulo, Brazil. 
// The clustering goal is to generate clusters of properties sharing similar physical attributes.
// The attributes selected for clustering are utilized to calculate the municipal property taxes:
// https://web1.sf.prefeitura.sp.gov.br/CartelaIPTU/  
// The raw dataset can be downloaded from:
// http://geosampa.prefeitura.sp.gov.br/PaginasPublicas/_SBC.aspx (Cadastro > IPTU > IPTU_2019)

EXPORT File_Housing := MODULE
  EXPORT Layout := RECORD
		STRING numero_do_contribuinte;
		STRING ano_do_exercicio;
		STRING numero_da_nl;
		STRING data_do_cadastramento;
		STRING tipo_de_contribuinte_1;
		STRING cpf_cnpj_do_contribuinte_1;
		STRING nome_do_contribuinte_1;
		STRING tipo_de_contribuinte_2;
		STRING cpf_cnpj_do_contribuinte_2;
		STRING nome_do_contribuinte_2;
		STRING numero_do_condominio;
		STRING codlog_do_imovel;
		STRING nome_de_logradouro_do_imovel;
		STRING numero_do_imovel;
		STRING complemento_do_imovel;
		STRING bairro_do_imovel;
		STRING referencia_do_imovel;
		STRING cep_do_imovel;
		STRING quantidade_de_esquinas_frentes;
		STRING fracao_ideal;
		STRING area_do_terreno;
		STRING area_construida;
		STRING area_ocupada;
		STRING valor_do_m2_do_terreno;
		STRING valor_do_m2_de_construcao;
		STRING ano_da_construcao_corrigido;
		STRING quantidade_de_pavimentos;
		STRING testada_para_calculo;
		STRING tipo_de_uso_do_imovel;
		STRING tipo_de_padrao_da_construcao;
		STRING tipo_de_terreno;
		STRING fator_de_obsolescencia;
		STRING ano_de_inicio_da_vida_do_contribuinte;
		STRING mes_de_inicio_da_vida_do_contribuinte;
		STRING fase_do_contribuinte;
		STRING zona;
		STRING profundidade_eq;
		STRING fatordeprof;
		STRING condominio;
		STRING fator_terreno;
		STRING area_exc;
		STRING construcao;
		STRING terreno;
		STRING excesso;
  END;

  EXPORT File:=DATASET('~Tutorial::Clustering::Housing',Layout,CSV(HEADING(1)));
 
 //New record structure for the property attributes that will be clustered
	EXPORT MLHousing := RECORD
	  //REAL field types will be standardized for clustering
		REAL NumberOfFronts;				// Number of fronts from the property
		REAL LandSquareFootage;     // Square footage from the property land
		REAL LivingSquareFootage;		// Square footage from the property living areas
		REAL BuildingSquareFootage; // Square footage from the property building
		REAL YearBuilt;             // Year that property was built
		REAL NumberOfFloors;        // Number of floors from the property
		REAL FrontLinearFeet;       // Front linear feet from the property
		REAL CityZone;              // City zone where the property is located
		REAL CondominiumAdj;        // Adjustment factor if the property is located in a condo
		REAL LandExcess;            // Property land that is not used for living
		REAL BuildingValue;         // Assessed value from the property building
		REAL LandValue;             // Assessed value from the property land
		REAL ExcessValue;           // Assessed value from the property land excess
		//Non-REAL field types will not be used for clustering
		UNSIGNED8 PropertyID;       // Unique Id of the property
		UNSIGNED4 ZipCode;          // Zipcode of the property
	END;
END;
//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.Prep01
IMPORT $,STD;

Housing    := $.File_Housing.File;
ML_Housing := $.File_Housing.MLHousing;

EXPORT Prep01 := MODULE
  EXPORT MLHousExt := RECORD(ML_Housing)
    UNSIGNED4 rnd; // A random number
	END;
	
 // Format the data and assign a random number to each record
 MLHousExt ML_Clean (Housing Le) := TRANSFORM
   SELF.rnd                   := RANDOM();
	 SELF.NumberOfFronts        := (REAL)Le.quantidade_de_esquinas_frentes;
	 SELF.LandSquareFootage     := (REAL)Le.area_do_terreno;
	 SELF.LivingSquareFootage   := (REAL)Le.area_construida;
	 SELF.BuildingSquareFootage := (REAL)Le.area_ocupada;
	 SELF.YearBuilt             := (REAL)Le.ano_da_construcao_corrigido;
	 SELF.NumberOfFloors        := (REAL)Le.quantidade_de_pavimentos;
	 SELF.FrontLinearFeet       := (REAL)Le.testada_para_calculo;
	 SELF.CityZone              := (REAL)MAP(Le.zona='1SZU'=>1,Le.zona='2SZU'=>2,Le.zona='3SZU'=>3,0);
	 SELF.CondominiumAdj        := (REAL)IF(Le.condominio <>'1',1,0),;
	 SELF.LandExcess            := (REAL)Le.area_exc;
	 SELF.BuildingValue         := (REAL)Le.construcao;
	 SELF.LandValue             := (REAL)Le.terreno;
	 SELF.ExcessValue           := (REAL)Le.excesso;
	 SELF.PropertyID            := (UNSIGNED8)STD.Str.FindReplace(Le.numero_do_contribuinte,'-','');;
	 SELF.ZipCode               := (UNSIGNED4)STD.Str.FindReplace(Le.cep_do_imovel,'-','');
	END;

  EXPORT myDataE := PROJECT(Housing, ML_Clean(LEFT));
	                     
  // Shuffle your data by sorting on the random field
  SHARED myDataES := SORT(myDataE, rnd);
  // Now cut the deck and you have random samples
  // While you're at it, project back to your original format -- we dont need the rnd field anymore
  // Treat first 5000 as training data.  Transform back to the original format.
  EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Housing);
                              
END;
//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.Train03_DBScan
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
//Import:ecl:Workshops.CommDay2021.Hour1.Clustering.Train03_KMeans
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
