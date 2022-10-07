/**
 * Joins the Base dataset with the AddChg dataset to produce a 
 * new base dataset with all adds, changes, and deletions implemented.
 *
 * @param Base          The base dataset.
 * @param AddChg        The add/change/delete dataset. Must be same structure as Base.
 * @param idlist        A string containing the comma-delimited list of fields that create the unique ID for reach record.
 * @param fieldlist     A string containing the comma-delimited list of fields that may have changed.
 * @return              A record set of the new base records.
 */
IMPORT $;
EXPORT IncrementalAddChgMulti(Base, AddChg, idlist, fieldlist) := FUNCTIONMACRO
 tbl1 := TABLE(Base,{UNSIGNED8 UID := HASH64(#EXPAND(idlist)), Base});
 tbl2 := TABLE(AddChg,{UNSIGNED8 UID := HASH64(#EXPAND(idlist)), AddChg});
 list := idlist + ',' + fieldlist;
 New  := $.IncrementalAddChgRecs(tbl1, tbl2, UID, list);
 RETURN PROJECT(New,RECORDOF(Base));
ENDMACRO;
