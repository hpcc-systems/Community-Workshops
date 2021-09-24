IMPORT $;
IMPORT ML_Core;

myTrainData := $.Prep01_MI.myTrainData;
myTestData  := $.Prep01_MI.myTestData;

//Numeric Field Matrix conversion
ML_Core.ToField(myTrainData, myTrainDataNF,wiField := wi_id);
ML_Core.ToField(myTestData, myTestDataNF,wiField := wi_id);
// OUTPUT(myTrainDataNF, NAMED('TrainDataNF'));  //Spot the Numeric Field Matrix conversion
// OUTPUT(myTestDataNF, NAMED('TestDataNF'));  //Spot the Numeric Field Matrix conversion

EXPORT Convert02_MI := MODULE
  //We have 9 independent fields and the last field (10) is the dependent
  EXPORT myIndTrainDataNF := myTrainDataNF(number < 10); // Number is the field number
  EXPORT myDepTrainDataNF := PROJECT(myTrainDataNF(number = 10), 
                                     TRANSFORM(RECORDOF(LEFT), 
                                               SELF.number := 1,
                                               SELF := LEFT));
  EXPORT myIndTestDataNF := myTestDataNF(number < 10); // Number is the field number
  EXPORT myDepTestDataNF := PROJECT(myTestDataNF(number = 10), 
                                    TRANSFORM(RECORDOF(LEFT), 
                                              SELF.number := 1,
                                              SELF := LEFT));
END;
