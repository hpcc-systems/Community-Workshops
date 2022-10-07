EXPORT ZoneLookup := MODULE 
 Layout := RECORD 
  UNSIGNED2 LocationID;
  STRING Borough;
  STRING Zone;
  STRING service_zone;
 END;
 EXPORT File:= DATASET('~dg::taxi_zone_lookup.csv',Layout,CSV(HEADING(1)));
 // Dictonary definition to index LocationID and payload Zone field
 EXPORT DCT := DICTIONARY(File,{LocationID => Zone}); 
 // Function that takes an id and returns the Zone field
 EXPORT ID2Zone(UNSIGNED2 id) := DCT[id].Zone;
END;
