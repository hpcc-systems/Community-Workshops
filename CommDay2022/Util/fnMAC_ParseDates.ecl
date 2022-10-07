/**
 * Parses date strings from the 20 most common formats
 * into standard YYYYMMDD UNSIGNED4 dates
 *
 * @param ds          The name of the dataset to parse.
 * @param datefield   The name of the field in the dataset to parse.
 * @return            A record set in the same format as the input dataset
 *                    with an UNSIGNED4 YYYYMMDD field and a STRING8 Time field
 *                    appended.
 */
EXPORT fnMAC_ParseDates(ds,datefield) := FUNCTIONMACRO
  IMPORT STD;

  //the "atomic" bits:
  PATTERN Alpha := PATTERN('[A-Za-z]')+; //any number of alpha characters together  
  PATTERN Nbr   := PATTERN('[0-9]');     //a single numeric digit
  PATTERN Sep   := PATTERN('[-, /.]');   //separators -- note the "space" character

  //more complex building blocks:
  PATTERN Ws    := Sep OPT(Sep);         //"white space" = 1 or 2 separators
  PATTERN Num12 := OPT(Nbr) Nbr;					//a 1 or 2-digit number
  PATTERN Year  := Nbr Nbr OPT(Nbr Nbr);	//a 2 or 4-digit number, explicit

  PATTERN AMPM  := Num12 ':' Num12 OPT(':' Num12) ' ' Alpha;
  PATTERN Zulu  := Num12 ':' Num12 ':' Num12;
  PATTERN Time  := (AMPM | Zulu);

  //a pattern using VALIDATE:
  SetMonths := ['JAN','FEB','MAR','APR',
                'MAY','JUN','JUL','AUG',
                'SEP','OCT','NOV','DEC'];
  isValidMon(STRING txt) := Std.Str.ToUppercase(txt[1..3]) IN SetMonths;
  PATTERN Month := VALIDATE(Alpha,isValidMon(MATCHTEXT));

  //the final parsing patterns:
  PATTERN NumDate    := Num12 Ws Num12 Ws Year OPT(Ws+ Time);
  PATTERN AlphaDate1 := Month Ws Num12 Ws Year OPT(Ws+ Time);
  PATTERN AlphaDate2 := Num12 Ws Month Ws Year OPT(Ws+ Time);

  //and the RULE to do the pattern matching:
  RULE DateRule := (NumDate | AlphaDate1 | AlphaDate2);

  //the PARSE code:
  OutRec := RECORD
    RECORDOF(ds);
    UNSIGNED4 YYYYMMDD;
    STRING8   Time;
  END;						 

  OutRec XF(ds Le) := TRANSFORM
    //determine which pattern matched
    WhichPtn := WHICH(MATCHED(NumDate),
                      MATCHED(AlphaDate1),
                      MATCHED(AlphaDate2));

    //determine if numeric date is in 
    //"dd mm" (british) format instead of "mm dd": 
    P1 := IF(WhichPtn = 1,
             MATCHTEXT(NumDate/Num12[1]),
             '');
    P2 := IF(WhichPtn = 1,
             MATCHTEXT(NumDate/Num12[2]),
             '');
    //if first pair of digits can't be a month, 
    //flag as "B"ritish, else "A"merican format
    P3 := IF((UNSIGNED1)P1 > 12,'B','A');  
		
    DayNum := (UNSIGNED1)
              CHOOSE(WhichPtn,
                     IF(P3 = 'B',P1,P2),          
                     MATCHTEXT(AlphaDate1/Num12), 
                     MATCHTEXT(AlphaDate2/Num12));
    STRING2 Day := INTFORMAT(DayNum,2,1);

    //determine how the month is represented
    STRING3 M1 := Std.Str.ToUppercase(
             CHOOSE(WhichPtn,
                    '',                            //pattern 1
                    MATCHTEXT(AlphaDate1/Alpha),   //pattern 2
                    MATCHTEXT(AlphaDate2/Alpha))); //pattern 3
    Mds := DATASET(12,
                   TRANSFORM({UNSIGNED C,STRING txt},
                             SELF.C := COUNTER,
                             SELF.txt := SetMonths[COUNTER]));
    M2 := Mds(txt = M1)[1].C;
    Month := INTFORMAT(IF(WhichPtn = 1,
                          (UNSIGNED1)IF(P3 = 'B',P2,P1),
                          M2),
                       2,1);                

    //handle 2 vs 4-digit years
    PYear := CHOOSE(WhichPtn,
                    MATCHTEXT(NumDate/Year),      //pattern 1
                    MATCHTEXT(AlphaDate1/Year),   //pattern 2
                    MATCHTEXT(AlphaDate2/Year));  //pattern 3
    STRING4 Year := IF(LENGTH(PYear) = 4,
                       PYear,
                       IF(PYear >= '80',
                          '19'+Pyear,
                          '20'+Pyear));

    //and put it all together in a standard format																
    SELF.YYYYMMDD := (UNSIGNED4)(Year+Month+Day);

    //and standardize the time
    isAMPMtime := MATCHED(Time/AMPM);
    isAMPMSecs := MATCHED(Time/AMPM/Num12[3]);
    AMPMhr     := (UNSIGNED1)
                     MATCHTEXT(Time/AMPM/Num12[1]);
    AMPMhrStr:= IF(MATCHTEXT(Time/AMPM/Alpha)='PM',
                   ((STRING2)(AMPMhr + 12)),
                   INTFORMAT(AMPMhr,2,1));
    SELF.Time := MAP(
                  isAMPMtime AND isAMPMSecs => 
                      AMPMhrStr + ':' + 
                      MATCHTEXT(Time/AMPM/Num12[2]) 
                      + ':' + 
                      MATCHTEXT(Time/AMPM/Num12[3]),
                  isAMPMtime AND NOT isAMPMSecs => 
                      AMPMhrStr + ':' + 
                      MATCHTEXT(Time/AMPM/Num12[2])
                      + ':00',
                  MATCHTEXT(Time/Zulu));
		SELF := Le;
  END;
  RETURN PARSE(ds,datefield,DateRule,XF(LEFT),BEST);
ENDMACRO;
