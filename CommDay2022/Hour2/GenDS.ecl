IMPORT Std, $.^.Util;
SD := Std.Date;

EXPORT GenDS := MODULE
 SHARED Recs2Gen     := 10000;
 SHARED Filename     := '~DG::DS::GenDS';
 SHARED iDescIDXname := '~DG::IDX::iDesc';
 SHARED sDescIDXname := '~DG::IDX::sDesc';
 SHARED GenBdate := FUNCTION
  StartDate := SD.FromGregorianYMD(1950,1,1);
  EndDate   := SD.FromGregorianDate(SD.Today()); DateSpan  := EndDate - StartDate;
  RETURN SD.ToGregorianDate((RANDOM() % DateSpan) + StartDate);
END;

EXPORT Layout := RECORD
 UNSIGNED4 RecID;
 UNSIGNED4 Bdate;
 STRING40  Name;
END;

 CntLnames := COUNT($.Names.Last);
 CntFnames := COUNT($.Names.First);
 SHARED GetName(C) := FUNCTION  
  WhichLast  := ((C + RANDOM()) % CntLnames)+1;
  WhichFirst := ((C + RANDOM()) % CntFnames)+1;
  RETURN TRIM($.Names.Last[WhichLast].name) + ', ' + $.Names.First[WhichFirst].name;
END; 

Layout XF(INTEGER C) := TRANSFORM
 SELF.RecID := C;
 SELF.Bdate := GenBdate;
 SELF.Name  := Std.Str.ToTitleCase(GetName(C));
END;
 DS := DATASET(Recs2Gen,XF(COUNTER));
 EXPORT GenDS := OUTPUT(DS,,Filename,OVERWRITE);
 EXPORT File := DATASET(Filename,Layout,FLAT);


 EXPORT iDescIDX := INDEX(File,{INTEGER4 NegDate := -(INTEGER4)Bdate},{File},iDescIDXname);
 EXPORT Bld_iDescIDX := BUILD(iDescIDX,OVERWRITE);


 EXPORT sDescIDX := INDEX(File, {STRING40 RevName := Util.BitFlipStr(Name)}, {File},sDescIDXname);
 EXPORT Bld_sDescIDX := BUILD(sDescIDX,OVERWRITE);
 END;
