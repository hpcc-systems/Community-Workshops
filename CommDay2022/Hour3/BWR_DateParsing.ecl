IMPORT $.^.Util; //make ParseDates available
myds := DATASET([
  {1,'25 MAY. 2005'},  
  {2,'30/08/2009'},  
  {3,'Thursday, March 7, 2013 - 1:30 PM'},
  {4,'7 SEP, 2006'},   
  {5,'18-09-2008'},  
  {6,'SAT, 04/27/2013 - 1:30:24 AM'},
  {7,'25 MARCH 2013'}, 
  {8,'22.01.2013'},  
  {9,'15-MAR-2004'}, 
  {10,'3-14-13'},      
  {11,'13/03/20'},   
  {12,'27/08/85 17:45:30'}],
  {UNSIGNED1 UID,STRING40 s});

//***********************************************************************
//using Standard Library function:
IMPORT Std;
SetFormats := [ 
  '%m/%d/%Y',   '%d/%m/%Y',   '%m/%d/%y',    
  '%d/%m/%y',   '%m.%d.%Y',   '%d.%m.%Y',   
  '%m.%d.%y',   '%d.%m.%y',   '%m-%d-%Y',   
  '%d-%m-%Y',   '%m-%d-%y',   '%d-%m-%y',
  '%d%t%B%t%y', '%d%t%b%t%y', '%d%t%B.%t%y', 
  '%d%t%b.%t%y','%d-%B-%y',   '%d-%B-%Y',   
  '%d-%b-%y']; 

OutRec2 := RECORD
  UNSIGNED1 UID;
  STRING40  InputStr;
  UNSIGNED4 Date;
END;
pstd := PROJECT(myds,
                TRANSFORM(OutRec2,
                          SELF.UID      := LEFT.UID,
                          SELF.InputStr := LEFT.s,
                          SELF.Date     := Std.Date.MatchDateString(LEFT.s,SetFormats)));
OUTPUT(pstd,NAMED('pstd'));

//From the Date.ecl file:										 
// /**
 // * Matches a string against a set of date string formats and returns a valid
 // * Date_t object from the first format that successfully parses the string.
 // *
 // * @param date_text     The string to be converted.
 // * @param formats       A set of formats to check against the string.
 // *                      (See documentation for strftime)
 // * @return              The date that was matched in the string.
 // *                      Returns 0 if failed to match.
 // */

// EXPORT Date_t MatchDateString(STRING date_text, SET OF VARSTRING formats) :=
    // StringLib.MatchDate(date_text, formats);

// strftime docs here:		http://www.cplusplus.com/reference/ctime/strftime/
// and here:             http://en.cppreference.com/w/c/chrono/strftime

//***********************************************************************
//using DefinitiveGuide.Util.fnMac_ParseDates function:

parsed := Util.fnMAC_ParseDates(myds,s);
OUTPUT(parsed,NAMED('parsed'));


JOIN(parsed,pstd, LEFT.UID = RIGHT.UID,
     TRANSFORM({UNSIGNED1 UID,STRING40 InputStr,UNSIGNED4 YYYYMMDD, UNSIGNED4 Date, STRING3 Match},
               SELF.Match := IF(LEFT.YYYYMMDD = RIGHT.Date,'yes','NO'); 
               SELF := LEFT; SELF := RIGHT));
