//Import:ecl:Workshops.CommDay2021.Hour2.LinearReg.BWR_ViewPrepData
IMPORT $;
// Browse raw input data
OUTPUT($.File_Property.File,NAMED('Property'));
COUNT($.File_Property.File);

// Browse clean input data
// OUTPUT($.Prep01.myDataE,NAMED('CleanProperty'));
// COUNT($.Prep01.myDataE);

// Browse clean train data and test data
// OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
// COUNT($.Prep01.myTrainData);
// OUTPUT($.Prep01.myTestData,NAMED('TestData'));
// COUNT($.Prep01.myTestData);

// Browse converted train and test data
// OUTPUT($.Convert02.myIndTrainDataNF,NAMED('IndTrain'));
// OUTPUT($.Convert02.myDepTrainDataNF,NAMED('DepTrain'));
// OUTPUT($.Convert02.myIndTestDataNF,NAMED('IndTest'));
// OUTPUT($.Convert02.myDepTestDataNF,NAMED('DepTest'));


//Import:ecl:Workshops.CommDay2021.Hour2.LinearReg.Convert02
IMPORT $;
IMPORT ML_Core;

myTrainData := $.Prep01.myTrainData;
myTestData  := $.Prep01.myTestData;

//Add a sequential ID - CRITICAL to this bundle
ML_Core.AppendSeqId(myTrainData,id,myTrainIDData);
ML_Core.AppendSeqId(myTestData,id,myTestIDData);

//Numeric Field Matrix conversion
ML_Core.ToField(myTrainIDData, myTrainDataNF);
ML_Core.ToField(myTestIDData, myTestDataNF);
// OUTPUT(myTrainDataNF, NAMED('TrainDataNF'));  //Uncomment to spot the Numeric Field Matrix conversion
// OUTPUT(myTestDataNF, NAMED('TestDataNF'));  //Uncomment to spot the Numeric Field Matrix conversion

//* <-- Delete the first forward slash (/) just before the asterisk (*) to comment out the entire MODULE
EXPORT Convert02 := MODULE
   //We have 8 independent fields and the last field (9) is the dependent
   EXPORT myIndTrainDataNF := myTrainDataNF(number < 9); // Number is the field number
   EXPORT myDepTrainDataNF := PROJECT(myTrainDataNF(number = 9), 
                                      TRANSFORM(RECORDOF(LEFT), 
                                                SELF.number := 1,
                                                SELF := LEFT));
   EXPORT myIndTestDataNF := myTestDataNF(number < 9); // Number is the field number
   EXPORT myDepTestDataNF := PROJECT(myTestDataNF(number = 9), 
                                     TRANSFORM(RECORDOF(LEFT), 
                                               SELF.number := 1,
                                               SELF := LEFT));
   																									
END;
// */
//Import:ecl:Workshops.CommDay2021.Hour2.LinearReg.File_Property
// The dataset we are using contains ficticious information from properties. 
// The regression goal is to train a model that can predict property prices.
// The raw dataset can be downloaded from our online ECL Training Advanced ECL (part1) class:
// https://learn.lexisnexis.com/Activity/1102# (OnlineProperty)

EXPORT File_Property := MODULE
  //Original record structure for property dataset
  EXPORT Layout := RECORD
   UNSIGNED8 personid;
   INTEGER8  propertyid;
   STRING10  house_number;
   STRING10  house_number_suffix;
   STRING2   predir;
   STRING30  street;
   STRING5   streettype;
   STRING2   postdir;
   STRING6   apt;
   STRING40  city;
   STRING2   state;
   STRING5   zip;
   UNSIGNED4 total_value;
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
  END;
  EXPORT File := DATASET('~Tutorial::LinearRegression::Property',Layout,THOR);
  //New record structure for training the property price model
	EXPORT MLProp := RECORD
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
   UNSIGNED4 total_value; //Dependent Variable - what we are trying to predict
  END;
END;

//Import:ecl:Workshops.CommDay2021.Hour2.LinearReg.Prep01
IMPORT $;
Property := $.File_Property.File;
ML_Prop  := $.File_Property.MLProp;

EXPORT Prep01 := MODULE
  MLPropExt := RECORD(ML_Prop)
    UNSIGNED4 rnd; // A random number
  END;
  // Clean the data and assign a random number to each record
  CleanFilter := Property.zip <> '' AND Property.assessed_value <> 0 AND Property.year_acquired <> 0 AND 
                 Property.land_square_footage <> 0 AND Property.living_square_feet <> 0 AND 
                 Property.bedrooms <> 0 AND Property.year_Built <> 0;
							 
  EXPORT myDataE := PROJECT(Property(CleanFilter), TRANSFORM(MLPropExt, 
                                                             SELF.rnd := RANDOM(),
                                                             SELF := LEFT));
																														 
  // Shuffle your data by sorting on the random field
  SHARED myDataES := SORT(myDataE, rnd);
  // Now cut the deck and you have random samples within each set
  // While you're at it, project back to your original format -- we dont need the rnd field anymore
  // Treat first 5000 as training data.  Transform back to the original format.
  EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Prop);  
  // Treat next 2000 as test data
  EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Prop); 
END;


//Import:ecl:Workshops.CommDay2021.Hour2.LinearReg.Train03
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


