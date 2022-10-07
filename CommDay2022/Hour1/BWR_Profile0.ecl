IMPORT $, Std;  
ds        := $.File_Yellow.SuperFile; 
Fld       := ds.VendorID;     
      
//1 -- Are there any non-numeric characters in the field? 
NbrChars  := '1234567890.-,';       //valid numeric chars 
Sub       := Std.Str.SubstituteIncluded(Fld,NbrChars,''); 
IsNumeric := NOT EXISTS(ds(Sub <> '')); 
OUTPUT(IsNumeric,NAMED('AllNumeric')); 

//2 -- If it is text, what is the maximum text length? 
TxtMaxLen := IF(NOT IsNumeric,MAX(ds,LENGTH(fld)),0); 
OUTPUT(TxtMaxLen,NAMED('TxtMaxLen'));

//3 -- If it is numeric, are the values integers or floating point? 
IsFloat := IsNumeric AND EXISTS(ds(Std.Str.Find(fld,'.',1)<>0)); 
OUTPUT(IsFloat,NAMED('IsFloat'));

//4 -- If it is numeric, what is the range of values? 
MinVal    := MIN(ds,fld); 
MaxVal    := MAX(ds,fld); 
OUTPUT(MinVal,NAMED('MinVal')); 
OUTPUT(MaxVal,NAMED('MaxVal'));

//5 -- How many unique values are present? 
ValTbl := TABLE(ds,
               {val := fld,
                INTEGER GrpCnt := COUNT(GROUP)},
                fld); 
ValCnt := COUNT(ValTbl); 
OUTPUT(ValCnt,NAMED('ValCnt'));

//6 -- What do the data patterns look like? 
txtX    := REGEXREPLACE('[A-Za-z]',fld,'X');
txt9    := REGEXREPLACE('[0-9]',txtX,'9'); 
PatTbl1 := TABLE(ds,
                 {STRING Pat := txt9}); 
PatTbl2 := TABLE(PatTbl1,
                 {Pat,
                  INTEGER PatCnt := COUNT(GROUP)},
                  Pat);
Patterns := SORT(PatTbl2,-PatCnt);
OUTPUT(Patterns,NAMED('Patterns'));

//7 -- How skewed are the values? 
SkewSrt  := TOPN(ValTbl,10,-GrpCnt);  //top 10
SkewPct(UNSIGNED n) := REALFORMAT((n/COUNT(ds))*100,8,4); 
DataSkew := TABLE(SkewSrt,{SkewSrt,STRING Pct := SkewPct(GrpCnt)});
OUTPUT(Dataskew,NAMED('DataSkew'));

