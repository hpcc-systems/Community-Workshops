IMPORT Std;
EXPORT Profile := MODULE
 EXPORT Layout := RECORD 
  STRING   FieldName;
  STRING   FieldType;
  UNSIGNED TxtMaxLen;
  STRING   ValueRange;
  UNSIGNED ValueCount;
  DATASET({STRING Pat, INTEGER PatCnt}) Patterns;
  DATASET({STRING Val, INTEGER GrpCnt, STRING8 Pct}) DataSkewTbl;
 END;

 EXPORT Func(DATASET({STRING fld}) ds, STRING FieldName) := FUNCTION
  NbrChars  := '1234567890.-,';
  DsCnt     := COUNT(ds);
  Sub       := Std.Str.SubstituteIncluded(ds.fld, NbrChars,'');
  IsNumeric := NOT EXISTS(ds(Sub <> '')); 
  HasDot    := Std.Str.Contains(ds.fld,'.',TRUE); 
	IsFloat   := IsNumeric AND EXISTS(ds(HasDot));
  FldType   := MAP(IsFloat  => 'REAL',
                   IsNumeric => 'INTEGER',
                   'STRING');
  TxtMaxLen := IF(NOT IsNumeric, MAX(ds,LENGTH(fld)),0);
  ValRange  := MAP(IsFloat => MIN(ds,(REAL)fld) + ' to ' + MAX(ds,(REAL)fld),
                   IsNumeric => MIN(ds,(INTEGER)fld) + ' to ' + MAX(ds,(INTEGER)fld),
                   MIN(ds,fld) + ' to ' + MAX(ds,fld));
  txtX      := REGEXREPLACE('[A-Za-z]',ds.fld,'X');
  txt9      := REGEXREPLACE('[0-9]',txtX,'9');
  ValTbl    := TABLE(ds,{Val := fld,STRING Pat := txt9,INTEGER GrpCnt:=COUNT(GROUP)},fld);
  PatTbl    := SORT(TABLE(ValTbl,{Pat,INTEGER PatCnt := SUM(GROUP,GrpCnt)}, Pat),-PatCnt); 
  ValCnt    := COUNT(ValTbl);
  SkewSrt   := TOPN(ValTbl,10,-GrpCnt); SkewTbl := TABLE(SkewSrt,{Val,GrpCnt,STRING8 Pct := REALFORMAT((GrpCnt/DsCnt)*100,8,4)});
  RETURN DATASET([{FieldName,FldType, TxtMaxLen,ValRange, ValCnt,PatTbl,SkewTbl}],Layout);
 END;
END; //MODULE

