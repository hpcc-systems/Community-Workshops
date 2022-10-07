IMPORT $, Std, $.^.Util, $.^.Hour1;

// Vertical "slice" to extract just the required information and calculate the duration of each trip
Tbl1 := TABLE(Hour1.TaxiData.File,{RecID,trip_distance,puLocationID,doLocationID,fare_amount, 
                                   UNSIGNED1 puHour   := Std.Date.Hour(tpep_pickup_time), 
                                   UNSIGNED1 puDOW    := Std.Date.DayOfWeek(tpep_pickup_date),
                                   UNSIGNED8 Duration := Util.TripTime(tpep_pickup_date,tpep_pickup_time, tpep_dropoff_date, tpep_dropoff_time)}); 

// local FUNCTION to format the average trip duration value to create a HHH:MM:SS string result
TimeStr(UNSIGNED8 t) := FUNCTION
 OutHours := INTFORMAT(t DIV Util.Secs.H,3,1);
 OutMins  := INTFORMAT((t DIV Util.Secs.M)%Util.Secs.M,2,1);
 OutSecs  := INTFORMAT(t % Util.Secs.M,2,1); 
 RETURN OutHours +':'+ OutMins +':'+ OutSecs;
END;

// "Group-by" table for calculating the average data for each unique pickup/drop off locations, day of the week and hour of the day. 
EXPORT ProdData := TABLE(Tbl1(Duration<>0,trip_distance<>0), {puLocationID,doLocationID,puDOW,puHour, 
                                                              GrpCnt      := COUNT(GROUP),
                                                              AvgDistance := (DECIMAL5_2)AVE(GROUP,trip_distance),
                                                              AvgFare     := (DECIMAL7_2)AVE(GROUP,fare_amount),
                                                              STRING10 AvgDuration := TimeStr(AVE(GROUP,Duration))}, 
																															puLocationID,doLocationID,puDOW,puHour)
                                                              : PERSIST('~DG::ProdData::persist');
