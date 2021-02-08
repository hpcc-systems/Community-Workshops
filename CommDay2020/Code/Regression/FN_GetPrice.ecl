IMPORT $,ML_Core;
IMPORT LearningTrees as LT;
     
            
EXPORT FN_GetPrice(zip, assess_val, year_acq, 
                  land_sq_ft, living_sq_ft, bedrooms, 
                  full_baths, half_baths, year_built) := FUNCTION
  myInSet := [zip, assess_val, year_acq, land_sq_ft, living_sq_ft, 
              bedrooms, full_baths, half_baths, year_built];
  myInDs := DATASET(myInSet, {REAL8 myInValue});
  ML_Core.Types.NumericField PrepData(RECORDOF(myInDS) Le, INTEGER C) := TRANSFORM
   SELF.wi     := 1,
   SELF.id     := 1,
   SELF.number := C,
   SELF.value := Le.myInValue;
  END;
  myIndepData := PROJECT(myInDs, PrepData(LEFT,COUNTER));
	
  // Model generated with maxTrees and maxdepth values equal to 10
  // mymodel := DATASET('~sengi::hmw::mymodelR',ML_Core.Types.Layout_Model2,FLAT,PRELOAD);
	
  myLearner := LT.RegressionForest(10,,10,[1]); // This is how you can limit maxTrees and maxdepth values to 10
  myModel   := myLearner.GetModel($.Convert02.myIndTrainDataNF, $.Convert02.myDepTrainDataNF);
  myPredictDeps := MyLearner.Predict(myModel, myIndepData);
      
  RETURN OUTPUT(myPredictDeps,{value});
            
END;
