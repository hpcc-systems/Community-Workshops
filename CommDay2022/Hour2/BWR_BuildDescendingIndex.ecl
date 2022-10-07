IMPORT Std,$.^.Util;
//STEP ONE: Generate the sample data and then the INDEXes
SEQUENTIAL($.GenDS.GenDS,$.GenDS.Bld_iDescIDX,$.GenDS.Bld_sDescIDX);

// STEP TWO: Demonstrate Date Reverse sort
WhichRec := 42;
OneRec := $.GenDS.File[WhichRec];
OUTPUT($.GenDS.File[WhichRec..WhichRec],NAMED('OneRec'));
OUTPUT($.GenDS.iDescIDX(-NegDate = OneRec.Bdate), ALL,NAMED('iDescIDX_OneRec'));
OUTPUT($.GenDS.iDescIDX(-NegDate BETWEEN 20100101 AND Std.Date.Today()), ALL,NAMED('iDescIDX_Range'));

// STEP THREE: Demonstrate the Descending Index
OUTPUT($.GenDS.sDescIDX(RevName = Util.BitFlipStr(OneRec.name)), NAMED('sDescIDX_OneRec'));
OUTPUT($.GenDS.sDescIDX(RevName BETWEEN Util.BitFlipStr('Miller') AND Util.BitFlipStr('Jones')),
       ALL,NAMED('sDescIDX_Range'));
 
 
/*  This code demonstrates using the sDescIDX INDEX to find a specific set of records. 
    It?s using the SAMPLE() function to get every 400th record from the original dataset. 
    Then the PROJECT() operation produces a record set of just the Name field values with their bits flipped, 
    so that the SET() function can create a set so we can use the IN operator for the filter. 
*/
Interval   := 400;
SampleRecs := SAMPLE($.GenDS.File, Interval);
Flips      := PROJECT(SampleRecs, TRANSFORM({SampleRecs.Name},
SELF.Name  := Util.BitFlipStr(LEFT.Name)));
SET OF STRING40 SampleSet := SET(Flips,Name);
OUTPUT(SORT(SampleRecs,-Name),NAMED('SampleRecs'));
OUTPUT($.GenDS.sDescIDX(RevName IN SampleSet),NAMED('sDescIDX_Set'));
       


