EXPORT Sets := MODULE
 EXPORT SortSet(s, ord='A') := FUNCTIONMACRO
  sds := DATASET(s,{TYPEOF(s[1]) e});
  srt := IF(#TEXT(ord)='A', SORT(sds,e), SORT(sds,-e));
  RETURN SET(srt,e);
 ENDMACRO;
 EXPORT RankSet(pos,s,ord='A') := FUNCTIONMACRO
  orig := s[pos];
  srtd := Util.Sets.SortSet(s,ord);
  RETURN Util.PosInSet(srtd,orig);
 ENDMACRO;
 EXPORT RankedSet(pos,s,ord='A') := FUNCTIONMACRO
  srtd := Util.Sets.SortSet(s,ord);
  post := srtd[pos];
  RETURN Util.PosInSet(s,post);
 ENDMACRO;
 EXPORT ToStr(s,d) := FUNCTIONMACRO
  r := {STRING t};
  r dsXF(INTEGER C) := TRANSFORM
   SELF.t := (STRING)s[C];
  END;
  sds := DATASET(COUNT(s),dsXF(COUNTER));
  r rXF(r Le,r Ri) := TRANSFORM
   SELF.t := Le.t + d + Ri.t;
  END;
 RETURN ROLLUP(sds,TRUE,rXF(LEFT,RIGHT))[1].t;
 ENDMACRO; 
END;
