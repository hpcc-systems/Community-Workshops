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