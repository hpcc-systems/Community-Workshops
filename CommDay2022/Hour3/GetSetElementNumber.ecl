IMPORT $.^.Util, Std;

//Dataset to provide the set elements:
ds := DATASET([{'Joe',42},{'Sam',88},{'Harry',17}],{STRING10 name,UNSIGNED1 age});

//Case insensitive search:
NameSet1 := SET(ds,Std.Str.ToUppercase(Name));
answer1 := Util.PosInSet(NameSet1,'JOE');
answer2 := Util.PosInSet(NameSet1,'JOEL');
OUTPUT(answer1,NAMED('STR_Found_nocase'));
OUTPUT(answer2,NAMED('STR_NotFound_nocase'));

//Case sensitive search:
NameSet2 := SET(ds,Name);
Answer3 := Util.PosInSet(NameSet2,'Sam');
Answer4 := Util.PosInSet(NameSet2,'SAM');
OUTPUT(answer3,NAMED('STR_Found_case2'));
OUTPUT(answer4,NAMED('STR_NotFound_case2'));

//integer search:
AgeSet := SET(ds,age);
Answer5 := Util.PosInSet(AgeSet,17);
Answer6 := Util.PosInSet(AgeSet,99);
OUTPUT(answer5,NAMED('INT_Found'));
OUTPUT(answer6,NAMED('INT_NotFound'));









