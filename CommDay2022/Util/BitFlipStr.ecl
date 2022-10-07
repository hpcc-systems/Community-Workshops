/**
 * Flips all bits in the passed string. When used in an INDEX build, 
 * this allows the INDEX to simulate a descending sort of a string search term.  
 *
 * @param s           A record set or dataset.
 * @return            A string with all bits flipped 
 */
EXPORT BitFlipStr(STRING s) := FUNCTION   
  rec    := {STRING Flip};
  AllOne := 11111111b;
  FlipOne(STRING1 c) := (>STRING1<)
                        (AllOne ^ (>UNSIGNED1<)c); 
  // FlipOne(STRING1 c) := (>STRING1<)
	                      // (BNOT (>UNSIGNED1<)c);   //this works too, creates an error but still runs
	                      // (BNOT (INTEGER4)(>UNSIGNED1<)c);   //this works without the error
  ds := DATASET(LENGTH(s),
                TRANSFORM(rec,
                          SELF.Flip := 
                            FlipOne(s[COUNTER])));
  rs := ROLLUP(ds,1=1,
               TRANSFORM(rec,
                         SELF.Flip := 
                           LEFT.Flip+RIGHT.Flip));
  RETURN rs[1].Flip; 
END;
