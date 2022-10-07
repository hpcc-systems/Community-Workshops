IMPORT $, Std;

// Function Structure that receives pickup and drop off dates/times as input and calculates the amount of seconds elapsed between them
EXPORT TripTime(Std.Date.Date_t puDate,Std.Date.Time_t puTime, Std.Date.Date_t doDate, Std.Date.Time_t doTime) := FUNCTION

// Nested function that receives a time parameter as input and returns the amount of seconds elapsed since 00:00AM
 TimeToSecsInDay(Std.Date.Time_t t) := FUNCTION
  s       := INTFORMAT(t,6,1);
  Hours   := (UNSIGNED1)s[1..2] * $.Secs.H;
  Minutes := (UNSIGNED1)s[3..4] * $.Secs.M;
  Seconds := (UNSIGNED1)s[5..6];
  RETURN Hours + Minutes + Seconds;
 END;
// Days elapsed between pickup and drop off
 doSecs   := TimeToSecsInDay(doTime);
 puSecs   := TimeToSecsInDay(puTime);
 TripDays := STD.Date.DaysBetween(puDate,doDate);

//  Total number of seconds elapsed between pickup and drop off
 RETURN doSecs + (TripDays * $.Secs.D) - puSecs;
END;
