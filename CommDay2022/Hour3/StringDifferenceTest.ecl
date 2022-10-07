IMPORT $.^.Util; //make StringDiff available

//simple example:
C1 := 'ABC DEF';
C2 := 'Abc Def Ghi';
Util.StringDiff(C1,C2);
Util.StringDiff(C1,C2,CS:=FALSE);

//extracting just the difference string:
STRING x1 := Util.StringDiff(C1,C2)[3].char;
x1;

STRING x2 := Util.StringDiff(C1,C2,JustDiffs:=TRUE)[1].char;
x2; 




