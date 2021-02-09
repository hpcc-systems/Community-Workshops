IMPORT $;
IMPORT ML_Core;
myTrainData := $.Prep01.myTrainData;
myTestData  := $.Prep01.myTestData;
//Numeric Field Matrix conversion
ML_Core.ToField(myTrainData, myTrainDataNF);
ML_Core.ToField(myTestData, myTestDataNF);
// Output(myTrainDataNF);
EXPORT Convert02 := MODULE
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
