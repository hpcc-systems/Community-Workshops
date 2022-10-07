EXPORT fnMAC_CompFormats(ds1, ds2) := FUNCTIONMACRO
 #DECLARE(struct1);
 #DECLARE(struct2);
 #EXPORT(struct1,ds1);
 #EXPORT(struct2,ds2);
 Str1 := %'struct1'%;
 Str2 := %'struct2'%;
 PATTERN namechar := PATTERN('[- ._:^A-Za-z0-9]')+;
 PATTERN filename := ' name="' namechar '"';
 ds := DATASET([{Str1},{Str2}],{STRING txt});
 ps := PARSE(ds,txt,filename,{res:=MATCHTEXT(filename/namechar)},BEST); 

 IMPORT Std;
 CmpStr1 := Std.Str.FindReplace(Str1, ps[1].res,'');
 CmpStr2 := Std.Str.FindReplace(Str2, ps[2].res,'');

// RETURN Str1 + '\n\n' + Str2;      //raw
// RETURN CmpStr1 + '\n\n' + CmpStr2; //final
 RETURN CmpStr1 = CmpStr2;
ENDMACRO;
