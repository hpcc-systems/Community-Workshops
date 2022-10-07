/**
 * Joins the Base dataset with the AddChg dataset to produce a 
 * new base dataset with all adds, changes, and deletions implemented.
 *
 * @param Base          The base dataset.
 * @param AddChg        The add/change/delete dataset. Must be same structure as Base.
 * @param id            The single unique ID field for both.
 *                      A negative id field value in AddChg = delete the record.
 * @param fieldlist     A string containing the comma-delimited list of fields that may have changed.
 * @return              A record set of the new base records.
 */

EXPORT IncrementalAddChgRecs(Base, AddChg, id, fieldlist) := FUNCTIONMACRO
 t1 := TABLE(Base,{id,UNSIGNED4 CRC1 := HASHCRC(#EXPAND(fieldlist))});
 t2 := TABLE(AddChg,{id,UNSIGNED4 CRC2 := HASHCRC(#EXPAND(fieldlist))});

//FULL OUTER JOIN to produce all possibilities:
 j  := JOIN(t1,t2,LEFT.id = RIGHT.id,FULL OUTER);

 NewRecs  := j(CRC1 = 0,id > 0);
 DelRecs  := j(id < 0);
 SameRecs := j(CRC2 = 0);
 ChgRecs  := j(CRC1 <> 0, CRC2 <> 0,CRC1 <> CRC2); 

 SetDel := SET(DelRecs,ABS(id));
 SetOld := SET(SameRecs,id);
 SetNew := SET(NewRecs,id) + SET(ChgRecs,id);

 NewBase := Base(id IN SetOld,id NOT IN SetDel) + AddChg(id IN SetNew);

 RETURN SORT(NewBase,id);
 ENDMACRO;
