IMPORT Std;
Hour := 60 * 60;
day  := hour * 24;
week := day * 7;
HourParts := Std.Date.SecondsToParts(hour);
DayParts  := Std.Date.SecondsToParts(day);
WeekParts := Std.Date.SecondsToParts(week);

INTFORMAT(HourParts.Date,8,1) + ' ' + 
INTFORMAT(HourParts.Time,6,1) + ' = ' + 
Std.Date.SecondsFromParts(HourParts.year,HourParts.month, HourParts.day, HourParts.hour, HourParts.minute, HourParts.second);

INTFORMAT(DayParts.Date,8,1) + ' ' + 
INTFORMAT(DayParts.Time,6,1) + ' = ' + 
Std.Date.SecondsFromParts(DayParts.year,DayParts.month, DayParts.day, DayParts.hour, DayParts.minute, DayParts.second);

INTFORMAT(WeekParts.Date,8,1) + ' ' + 
INTFORMAT(WeekParts.Time,6,1) + ' = ' + 
Std.Date.SecondsFromParts(WeekParts.year,WeekParts.month, WeekParts.day, WeekParts.hour, WeekParts.minute, WeekParts.second);
