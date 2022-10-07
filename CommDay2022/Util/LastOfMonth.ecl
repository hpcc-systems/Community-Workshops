EXPORT LastOfMonth(UNSIGNED4 D) := FUNCTION
 IMPORT Std;
 Y  := D DIV 10000;
 M  := (D % 10000) DIV 100;
 LD := Std.Date.FromGregorianYMD(Y,M+1,1) - 1;
 RETURN Std.Date.ToGregorianDate(LD);
END;
