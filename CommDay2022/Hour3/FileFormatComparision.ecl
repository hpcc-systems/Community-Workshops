IMPORT $.^.Hour1;
IMPORT $.^.Util;
ds1 := DATASET([{'A'},{'B'},{'C'},{'D'},{'E'},{'U'},{'V'},{'W'},{'X'},{'Y'}],{STRING1 Letter});
ds2 := DATASET([{'P'},{'Q'},{'R'},{'S'},{'T'},{'U'},{'V'},{'W'},{'X'},{'Y'}],{STRING1 Letter});
ds3 := DATASET([{'C','G'},{'C','C'},{'A','X'},{'A','G'},{'B','G'},{'A','B'}],{STRING1 Value1, STRING1 Value2}); 


ds4 := Hour1.File_Yellow.File_201701;
ds5 := Hour1.File_Yellow.File_201702;

$.fnMAC_CompFormats(ds1,ds2);
$.fnMAC_CompFormats(ds1,ds3);
$.fnMAC_CompFormats(ds4,ds5);


// ASSERT(Util.fnMAC_CompFormats(ds1,ds2),
// 'MISMATCHED FILE FORMATS -- ds1 != ds2',
// FAIL);
// ASSERT(Util.fnMAC_CompFormats(ds1,ds3),
// 'MISMATCHED FILE FORMATS -- ds1 != ds3',
// FAIL);
// ASSERT(Util.fnMAC_CompFormats(ds4,ds5),
// 'MISMATCHED FILE FORMATS -- ds4 != ds5',
// FAIL);
