IMPORT $.^.Util; //make the NULL module available
filename := '~dg::FromSQL.csv';
 MyRec := RECORD
  INTEGER ID;
  STRING MyString;
  STRING MyInteger;
END;
ds_out := DATASET([{1,'Fred','42'},
                   {2,'John','NULL'},
                   {3,'Hank','63'},
                   {4,'NULL','88'},
                   {5,'Ward','66'},
                   {6,'Lyle','NULL'}],MyRec); 

O1 := OUTPUT(ds_out,,filename,CSV,OVERWRITE,NAMED('CSV_File'));

ds_in := DATASET(filename,MyRec,CSV);
O2 := OUTPUT(ds_in,NAMED('InputRecs'));
// SEQUENTIAL(O1,O2);
//**********************



NullRec := RECORD
 INTEGER ID;
 Util.NULL.Str StrNull;
 Util.NULL.Int IntNull;
END;
NullRec XF(ds_in L) := TRANSFORM
 SELF.StrNull.Nil  := L.MyString='NULL';
 SELF.StrNull.Val  := IF(SELF.StrNull.Nil,'',L.MyString);
 SELF.IntNull.Nil  := L.MyInteger='NULL';
 SELF.IntNull.Val  := IF(SELF.IntNull.Nil,0,(INTEGER)L.MyInteger);
 SELF.ID           := L.ID; END;
P  := PROJECT(ds_in,XF(LEFT));
O3 := OUTPUT(P,,'~dg::NULLsImplemented',OVERWRITE,NAMED('NULL_Implemented'));
NullDS := DATASET('~dg::NULLsImplemented',NullRec,FLAT);

//**********************
NonNulls := NullDS(~StrNull.Nil,~IntNull.Nil);
O4 := OUTPUT(NonNulls,NAMED('NonNulls'));

MyRecs(DATASET(NullRec) ds) := TABLE(ds,{id, MyString  := StrNull.Val, MyInteger := IntNull.Val});

No_S_Nulls := MyRecs(NullDS(~StrNull.Nil)); No_I_Nulls := MyRecs(NullDS(~IntNull.Nil));
NoNulls    := MyRecs(NullDS(~StrNull.Nil,~IntNull.Nil));

O5 := OUTPUT(No_S_Nulls,NAMED('No_S_Nulls'));
O6 := OUTPUT(No_I_Nulls,NAMED('No_I_Nulls'));
O7 := OUTPUT(NoNulls,  NAMED('NoNulls'));

//reproduces original file, but with ASCII 0
//replacing the "NULL" value
OutRecs := PROJECT(NullDS, TRANSFORM(MyRec,
                                     SELF.MyString  := IF(LEFT.StrNull.Nil, Util.NULL.Out(1), LEFT.StrNull.Val),
                                     SELF.MyInteger := IF(LEFT.IntNull.Nil, Util.NULL.Out(1), (STRING)LEFT.IntNull.Val),
                                     SELF := LEFT));
O8 := OUTPUT(OutRecs,,'~dg::ToSQL',CSV,OVERWRITE,NAMED('To_SQL'));

Para := PARALLEL(O4,O5,O6,O7,O8);
SEQUENTIAL(O1,O2,O3,Para);
 






