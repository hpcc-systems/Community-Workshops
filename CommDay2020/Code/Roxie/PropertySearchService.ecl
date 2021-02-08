IMPORT $;
//uses payload which eliminates the need for an extra I/O FETCH
STRING15 FN_key := '' : STORED('FirstName');
STRING25 LN_key := '' : STORED('LastName');
base_key	:= $.IDX.BaseIDX;
	
EXPORT PropertySearchService(STRING25 LN_key, STRING15 FN_key) := FUNCTION
	Prop_filter := IF(FN_Key = '',
	                  base_key(lastname=LN_key),
										      base_key(lastname=LN_key,firstname=FN_key));
	RETURN Prop_filter;
END;
