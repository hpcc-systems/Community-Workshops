IMPORT $;
EXPORT ProdIDX := MODULE 

// First, BUILD the INDEXes
 EXPORT IndexSuperFile := '~dg::Taxi::IDXSF'; 
 EXPORT IndexFilename  := '~dg::Taxi::IDX'; 
 EXPORT BuildIDX := BUILD($.ProdData,{puLocationID,doLocationID, puDOW,puHour},
                          {$.ProdData}, IndexFilename, OVERWRITE);
                          
// Final Product Payload Index
 EXPORT Layout := RECORD
   UNSIGNED2 pulocationid; 
   UNSIGNED2 dolocationid; 
   UNSIGNED1 pudow; 
   UNSIGNED1 puhour
   =>
   INTEGER8   grpcnt; 
   DECIMAL5_2 avgdistance; 
   DECIMAL7_2 avgfare; 
   STRING10   avgduration;
   UNSIGNED8  internal_fpos__;
 END;

 EXPORT IDX   := INDEX(Layout, IndexFilename);
 EXPORT IDXSF := INDEX(Layout, IndexSuperFile);
END;

