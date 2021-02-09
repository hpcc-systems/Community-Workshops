IMPORT $;
OUTPUT($.Prep01.myDataE,NAMED('CleanProperty'));
COUNT($.Prep01.myDataE);
OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
COUNT($.Prep01.myTrainData);
OUTPUT($.Prep01.myTestData,NAMED('TestData'));
COUNT($.Prep01.myTestData);
// OUTPUT($.File_Property.File,,'~Property::BMF::Test',OVERWRITE);
