//FM to handle the mapping for any field in any file
EXPORT fnMAC_Txt2Code(inds,infield) := FUNCTIONMACRO
 //crosstab that groups the infield so that we end up with just the unique values from the infield 
 tbl  := TABLE(inds,{infield,Cnt := COUNT(GROUP)},infield);
 //placing the most common infield value at the top
 stbl := SORT(tbl,-Cnt);
 //PROJECT operation adds the mapping codes to the resulting record set
 RETURN PROJECT(stbl,TRANSFORM({STRING infield, UNSIGNED4 code}, SELF.code := COUNTER, SELF := LEFT));
ENDMACRO;