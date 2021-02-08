IMPORT $.^ AS Root;
IMPORT $;
// STRING15 FN_key := '' : STORED('FirstName');
// STRING25 LN_key := '' : STORED('LastName');
base_data := Root.File_PeopleAll.PeoplePlus; 
basekey	  := $.IDX.STDIDX;
	
EXPORT PropertyFetchService(STRING25 LN_key, STRING15 FN_key) := FUNCTION
	Prop_filter := IF(FN_Key = '',
	                  basekey(lastname=LN_key),
										      basekey(lastname=LN_key,firstname=FN_key));
	
	Prop_res := FETCH(base_data,Prop_filter,RIGHT.Recpos);
	RETURN Prop_res;
END;
