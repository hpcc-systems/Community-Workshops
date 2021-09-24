IMPORT $,STD;

//Browse raw input data
// OUTPUT($.File_Banking.File,NAMED('Banking'));
// COUNT($.File_Banking.File);
// COUNT($.File_Banking.File(y='0'));
// COUNT($.File_Banking.File(y='1'));

// Profiling the raw data
// STD.DataPatterns.Benford($.File_Banking.File);
// STD.DataPatterns.Profile($.File_Banking.File);

//Browse encoded input data 
// OUTPUT($.Prep01.myDataE,NAMED('EncodedBanking'));
// COUNT($.Prep01.myDataE);

// Browse encoded train data and test data
// OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
// COUNT($.Prep01.myTrainData);
// OUTPUT($.Prep01.myTestData,NAMED('TestData'));
// COUNT($.Prep01.myTestData);

// Browse converted train and test data
OUTPUT($.Convert02.myIndTrainDataNF,NAMED('IndTrain'));
OUTPUT($.Convert02.myDepTrainDataNF,NAMED('DepTrain'));
OUTPUT($.Convert02.myIndTestDataNF,NAMED('IndTest'));
OUTPUT($.Convert02.myDepTestDataNF,NAMED('DepTest'));
