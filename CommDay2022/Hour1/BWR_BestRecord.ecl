IMPORT $, Std;
ds := $.File_Yellow.Superfile;

BestRecord := Std.DataPatterns.BestRecordStructure(ds);
OUTPUT(BestRecord);
