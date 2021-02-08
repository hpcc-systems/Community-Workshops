IMPORT $.^ AS Root;
Property := Root.File_Property.File;
TaxData  := Root.File_Taxdata.File;
IsGTE(INTEGER A1, INTEGER A2) := A1 >= A2;
PropBeds3    := Property(IsGTE(Bedrooms,3));
TaxBeds3     := TaxData(IsGTE(Bedrooms,3));	
DedpTaxBeds3 := DEDUP(SORT(TaxBeds3, propertyid),propertyid); //Why GROUP?	
EXPORT PropTaxBeds3Norm := COUNT(JOIN(PropBeds3,DedpTaxBeds3,
                                      LEFT.propertyid=RIGHT.propertyid,
                                      FULL OUTER));
//Extra logic needed if you want to count People with 3 bedrooms.
																			
