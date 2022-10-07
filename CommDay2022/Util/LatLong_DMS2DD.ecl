/**
 * Parses a "Degree Minute Second" latitude/longitude string to produce a Digital Degree value.
 *
 * @param ps          The lat/long string to parse. This is expected to be a case sensitive string in any
 *                    of these formats (°=degrees,'=minutes,"=seconds, m=minutes, s=seconds):
 *                      35° 5' 27" N   //Degrees-Minutes-Seconds format
 *                      -35° 5' 27"    
 *                      35° 5m 27s S
 *                      35°5'27"S
 *                      35° 5.45'      //Degree-Decimal Minutes format
 *                      -35° 5.45'     
 *                      350527S        //Numeric format 
 *                      -350527        
 *                      
 * @return            A STRING containing the floating point Digital Degree value of the passed Lat/Long string. 
 */
IMPORT Std;
EXPORT LatLong_DMS2DD(STRING ps) := FUNCTION
  Nums     := '.0123456789';
  DegDelim := '°';
  MinDelim := ['\'','m'];                              //single quote or "m"
  SecDelim := ['"','s'];                               //double quote or "s"
  PosDirs  := ['N','E'];                               //positive directions
  NegDirs  := ['W','S'];                               //negative directions
  AllDirs  := PosDirs + NegDirs;
	
  DashPos := Std.Str.Find(ps,'-',1);                   //any minus sign?                 
  DotPos  := Std.Str.Find(ps,'.',1);                   //any decinal point? 
  DegPos  := Std.Str.Find(ps,DegDelim,1);              //where's the degree symbol?
  MinPos  := IF(Std.Str.Find(ps,MinDelim[1],1)=0,      //where's the minute symbol?
                Std.Str.Find(ps,MinDelim[2],1),	
                Std.Str.Find(ps,MinDelim[1],1));	
  SecPos  := IF(Std.Str.Find(ps,SecDelim[1],1)=0,      //where's the seconds symbol?
                Std.Str.Find(ps,SecDelim[2],1),	
                Std.Str.Find(ps,SecDelim[1],1));	

  NonNums := TRIM(Std.Str.FilterOut(ps,Nums),ALL);     //all non-numbers, no spaces, TRIM needed
  LenNons := LENGTH(NonNums);                          //get last non-digit character position
  DirChar := IF(NonNums[LenNons] IN AllDirs,           //is last non-digit character a direction?
                NonNums[LenNons],'');                  //get just the direction indicator
  Char1   := IF(DashPos<>0 OR DirChar IN NegDirs,      //needs leading minus?
                '-','');
  JustNums(STRING ss) := Std.Str.Filter(ss,Nums);      //all numbers, no spaces, no TRIM needed
	
  Forms := ENUM(UNSIGNED1,DMS,DM,DD,NUMS);             //the four formats
  DMS_Format := MAP(DegPos <> 0 AND MinPos <> 0        //which format is it?
                      AND SecPos <> 0                  //Degree-Minute-Second
                       => Forms.DMS,
                    DegPos <> 0 AND                    
	                    (DotPos <> 0 OR SecPos = 0)      //Degree-Minute
                       => Forms.DM,
                    DotPos <> 0                        //Digital Degree
                       => Forms.DD,
                    Forms.NUMS);                       //just numbers
	
  CalcDMS(STRING n) := FUNCTION                        //calculate from Degree-Minute-Second string
    Sec := (REAL)JustNums(n[MinPos+1..SecPos-1]);      //using the delimiter positions
    Mnt := (REAL)JustNums(n[DegPos+1..MinPos-1]);     
    Deg := (REAL)JustNums(n[1..DegPos-1]);            
    RETURN Char1 + 
           (STRING)(Deg+(Mnt/60)+(Sec/3600));
  END;

  CalcDM(STRING n) := FUNCTION                         //calculate from Degree-Minute string
    ns  := Std.Str.SplitWords(n,'°');                  //split on degree symbol
    Deg := (REAL)JustNums(ns[1]);                      //get degrees
    Mnt := (REAL)JustNums(ns[2]);                      //get minutes.seconds
    RETURN Char1 + (STRING)(Deg+(Mnt/60));
  END;

  CalcDD(STRING n) := Char1 + JustNums(n);             //string already in DD format
	
  CalcNUMS(STRING n) := FUNCTION                       //calculate from 6 or 7 digit numeric string
    ns  := JustNums(n);                                //remove non-digits
    LenNums := LENGTH(ns);                             //how many digits?
    Sec := (REAL)ns[LenNums-1..LenNums];               //last two
    Mnt := (REAL)ns[LenNums-3..LenNums-2];             //next to last two
    Deg := (REAL)ns[1..LenNums-4];                     //rest of them
    RETURN IF(LenNums BETWEEN 6 AND 7,
              Char1 + 
              (STRING)(Deg+(Mnt/60)+(Sec/3600)),
              '');
  END;

  RETURN CHOOSE(DMS_Format,
                CalcDMS(ps),
                CalcDM(ps),
                CalcDD(ps),
                CalcNUMS(ps)); 
END;


