MyRec := RECORD
  STRING1 Value1;
  STRING1 Value2;
END;
ParentFile := DATASET([{'C','A'},{'B','B'},{'A','C'}],MyRec);
ChildFile  := DATASET([{'C','X'},{'B','S'},{'C','W'},
                       {'B','Y'},{'A','Z'},{'A','T'}],MyRec);
MyOutRec := RECORD
  ParentFile.Value1;
  ParentFile.Value2;
  STRING1 CVal2_1 := '';
  STRING1 CVal2_2 := '';
END;
//Make ROOM for the children!!
P_Recs := TABLE(ParentFile, MyOutRec);
MyOutRec DeNormThem(MyOutRec Le, MyRec Ri, INTEGER Ct) := TRANSFORM
	SELF.CVal2_1 := IF(Ct = 1, Ri.Value2, Le.CVal2_1);
	SELF.CVal2_2 := IF(Ct = 2, Ri.Value2, Le.CVal2_2);
	SELF := Le;
END;
DeNormedRecs := DENORMALIZE(P_Recs, ChildFile,
							              LEFT.Value1 = RIGHT.Value1,
							              DeNormThem(LEFT,RIGHT,COUNTER));
OUTPUT(DeNormedRecs,NAMED('NestedChildDataset'));
