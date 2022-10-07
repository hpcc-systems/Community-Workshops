//FM that receives a SET "s" and an element "t" of the SET as tokens
EXPORT PosInSet(s, t) := FUNCTIONMACRO
  //TRANSFORM that produces just the element number 
	//of the elements that match the "t" token value  
	{INTEGER Num} XF(INTEGER C) := TRANSFORM
    SELF.Num := IF(s[C] = t,C,SKIP); 
	END;
  _ds := DATASET(COUNT(s),XF(COUNTER));
  //returns the number of the matching element in the SET  
	RETURN _ds[1].Num;
ENDMACRO;



