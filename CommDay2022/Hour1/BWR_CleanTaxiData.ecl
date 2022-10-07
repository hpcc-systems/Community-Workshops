IMPORT $;
IMPORT $.^.Util;

//Remove disputed and voided trips first
ValidTrips := $.File_Yellow.SuperFile(payment_type IN ['1','2']); //1=CC,2=Cash

//then number the recs
UIDrecs := Util.fnMAC_GenUID(ValidTrips(vendorid <> ''), $.Taxidata.UIDfilePrefix, RecID) : PERSIST('~DG::Taxi::persist::UIDrecs', EXPIRE(1));

//then clean/standardize the data
$.TaxiData.Layout CleanData(UIDrecs Le) := TRANSFORM
 //parse dates & times from text input
 SELF.tpep_pickup_date      := Std.Date.FromStringToDate(Le.tpep_pickup_datetime[1..10],'%Y-%m-%d');
 SELF.tpep_pickup_time      := Std.Date.FromStringToTime(Le.tpep_pickup_datetime[12..],'%H:%M:%S');
 SELF.tpep_dropoff_date     := Std.Date.FromStringToDate(Le.tpep_dropoff_datetime[1..10],'%Y-%m-%d');
 SELF.tpep_dropoff_time     := Std.Date.FromStringToTime(Le.tpep_dropoff_datetime[12..],'%H:%M:%S');
 //cast input data to new data types
 SELF.vendorid              := (UNSIGNED1)Le.vendorid;
 SELF.passenger_count       := (UNSIGNED1)Le.passenger_count;
 SELF.trip_distance         := (DECIMAL5_2)Le.trip_distance;
 SELF.ratecodeid            := (UNSIGNED1)Le.ratecodeid;
 SELF.store_and_fwd_flag    := (STRING1)Le.store_and_fwd_flag;
 SELF.pulocationid          := (UNSIGNED2)Le.pulocationid;
 SELF.dolocationid          := (UNSIGNED2)Le.dolocationid;
 SELF.payment_type          := (UNSIGNED1)Le.payment_type;
 SELF.fare_amount           := (DECIMAL9_2)Le.fare_amount;
 SELF.extra                 := (DECIMAL5_2)Le.extra;
 SELF.mta_tax               := (DECIMAL5_2)Le.mta_tax;
 SELF.tip_amount            := (DECIMAL5_2)Le.tip_amount;
 SELF.tolls_amount          := (DECIMAL5_2)Le.tolls_amount;
 SELF.improvement_surcharge := (DECIMAL3_2)Le.improvement_surcharge;
 SELF.total_amount          := (DECIMAL9_2)Le.total_amount;
 SELF                       := Le;
END; 

CleanRecs := PROJECT(UIDrecs,CleanData(LEFT));

OUTPUT(CleanRecs,,$.TaxiData.CleanFilename,OVERWRITE);
