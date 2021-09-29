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

