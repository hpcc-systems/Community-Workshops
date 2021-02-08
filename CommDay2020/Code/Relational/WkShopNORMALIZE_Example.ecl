FlatRec := RECORD
	STRING1 Value1;
	STRING1 Value2;
	STRING1 CVal2_1;
	STRING1 CVal2_2;
END;
FlatFile := DATASET([{'C','A','X','W'},{'B','B','S','Y'},
                     {'A','C','Z','T'}],FlatRec);
OutRec := RECORD
	FlatFile.Value1;
	FlatFile.Value2;
END;
P_Recs := TABLE(FlatFile, OutRec);
OutRec NormThem(FlatRec Le, INTEGER Cnt) := TRANSFORM
	SELF.Value2 := CHOOSE(Cnt,Le.CVal2_1, Le.CVal2_2);
	SELF.Value1 := Le.Value1;
END;
ChildRecs := NORMALIZE(FlatFile,2,NormThem(LEFT,COUNTER));
OUTPUT(ChildRecs,NAMED('ChildData'));
