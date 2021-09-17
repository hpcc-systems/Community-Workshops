IMPORT $,STD;

//Browse raw input data
OUTPUT($.File_Housing.File,NAMED('Housing'));
COUNT($.File_Housing.File);
// OUTPUT(STD.DataPatterns.Benford($.File_Housing.File));
// OUTPUT(STD.DataPatterns.Profile($.File_Housing.File));

// Browse formatted input data
// OUTPUT($.Prep01.myDataE,NAMED('FormattedHousing'));
// COUNT($.Prep01.myDataE);

//Browse train data
// OUTPUT($.Prep01.myTrainData,NAMED('MyTrainData'));

//Browse standardized and converted train data
// OUTPUT($.Convert02.myAggs,NAMED('BasicStats'));
// OUTPUT($.Convert02.myTrainDataSTD,NAMED('TrainDataStd'));
// OUTPUT($.Convert02.myTrainAttrNF,NAMED('TrainAttributesNF'));



