IMPORT $, Std;

ds1name := '~file_yellow::Profile::file_201701_'+ (STRING8)Std.Date.Today();
ds2name := '~file_yellow::Profile::file_201702_'+ (STRING8)Std.Date.Today();

file1 := OUTPUT($.fnMAC_Profile($.File_Yellow.File_201701),,ds1name,
                NAMED('ProfileInfo1'), OVERWRITE);
file2 := OUTPUT($.fnMAC_Profile($.File_Yellow.File_201702),,ds2name,
                NAMED('ProfileInfo2'), OVERWRITE);
       
ds1 := DATASET(ds1name, $.Profile.Layout,FLAT);
ds2 := DATASET(ds2name, $.Profile.Layout,FLAT); 

sAppend := SORT(ds1+ds2,fieldname);
//simply looking at the records side by side
compare := OUTPUT(sAppend,NAMED('BothProfiles'));

SEQUENTIAL(PARALLEL(file1,file2),compare);
       

