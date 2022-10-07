/**
 * Compares two string values and returns only the characters from 
 * the second string that are different from the same character position
 * in the first.
 *
 * @param S1          The "original" string.
 * @param S2          The "comparison" string.
 * @param CS          Indicates Case Sensitive/Insensitive comparison.
 * @param JustDiffs   Indicates returning just the difference string 
 *                    record or the inputs and the difference records.
 * @return            A 3-record record set. 
 *                    First and second records are the comparison strings.
 *                    The third record is a string with only the characters 
 *                    that are different, from the "comparison" string, in the 
 *                    exact positions where differences were found.
 */
IMPORT Std;
EXPORT StringDiff(STRING S1, STRING S2, 
                  BOOLEAN CS=TRUE, 
                  BOOLEAN JustDiffs=FALSE) := FUNCTION
  D1 := IF(CS,S1,Std.Str.ToUpperCase(S1));
  D2 := IF(CS,S2,Std.Str.ToUpperCase(S2));
  Repl(C) := IF(D1[C]=D2[C],' ',S2[C]);
  ds := DATASET(MAX(LENGTH(S1),LENGTH(S2)),
                TRANSFORM({STRING char},
                          SELF.char := Repl(COUNTER)));
  Rs := ROLLUP(ds,TRUE,
               TRANSFORM({STRING char},
                         SELF.char := LEFT.char + RIGHT.char))[1].char;	
  RetDS := DATASET([{'S1',S1},{'S2',S2},{'Rs',Rs}],{STRING2 rec,STRING char});
  RETURN IF(JustDiffs,RetDS[3..3],RetDS);
END;