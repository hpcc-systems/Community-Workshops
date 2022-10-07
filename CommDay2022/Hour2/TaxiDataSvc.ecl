IMPORT $, Std, $.^.Util; 

// INDEX that will be used in the query
IDX := $.ProdIDX.IDXSF;

// FUNCTION that takes pickup/drop off ids, day of the week and hour of the day and 
// returns the average values for trip durantion, fare and distance 
EXPORT TaxiDataSvc(UNSIGNED2 puid,UNSIGNED2 doid, UNSIGNED1 dow=99,UNSIGNED1 hour=99) := FUNCTION 

// EXPORT TaxiDataSvc() := FUNCTION 

// UNSIGNED2 puid :=  0 : STORED('puid');
// UNSIGNED2 doid :=  0 : STORED('doid');
// UNSIGNED1 dow  := 99 : STORED('dow');
// UNSIGNED1 hour := 99 : STORED('hour');

 NoDay  := dow = 99;  //true only if not passed 
 NoHour := hour = 99; //true only if not passed
 
// Filtering the INDEX to obtain the requested data
 IDXrecs:= MAP(NoDay AND NoHour => IDX(puLocationID = puid AND doLocationID = doid),
                         NoHour => IDX(puLocationID = puid AND doLocationID = doid AND puDOW = dow),
                         NoDay  => IDX(KEYED(puLocationID=puid AND doLocationID = doid AND puHour = hour),
                                       WILD(pudow)), IDX(puLocationID = puid AND doLocationID = doid AND
                                                         puDOW = dow AND puHour = hour));

// Local functions to format the query results into human-readable strigs
DayStr(UNSIGNED1 d) := CHOOSE(d,'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday',''); 
HrStr(UNSIGNED1 h)  := CHOOSE(h+1,'Midnight','1 AM','2 AM','3 AM','4 AM','5 AM','6 AM','7 AM',
                                  '8 AM','9 AM','10 AM','11 AM','Noon','1 PM','2 PM','3 PM',
                                  '4 PM','5 PM','6 PM','7 PM','8 PM','9 PM','10 PM','11 PM',
                              '');
OutRec := RECORD 
  STRING25 Pickup; 
  STRING25 Dropoff; 
  STRING10 Day; 
  STRING10 Hour; 
  STRING10 duration; 
  DECIMAL7_2 fare; 
  DECIMAL5_2 distance;
END;

OutRec XF(IDXrecs Le) := TRANSFORM
 SELF.Pickup   := $.ZoneLookup.ID2Zone(Le.puLocationID);
 SELF.Dropoff  := $.ZoneLookup.ID2Zone(Le.doLocationID); 
 SELF.Day      := DayStr(Le.puDOW);
 SELF.Hour     := HrStr(Le.puHour); 
 SELF.Duration := Le.avgDuration;
 SELF.Fare     := Le.avgFare;
 SELF.Distance := Le.avgDistance;
END;

RETURN PROJECT(IDXrecs,XF(LEFT));
END;
