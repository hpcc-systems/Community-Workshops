IMPORT Std;
EXPORT TaxiData := MODULE
 EXPORT UIDfilePrefix := '~dg::Taxi::globalUID_';
 EXPORT CleanFilename := '~dg::Taxi::Cleandata';
 EXPORT Layout := RECORD
   UNSIGNED8 RecID;
   UNSIGNED1 vendorid;
// STRING19 tpep_pickup_datetime;
// -- DataPatterns suggested data type
   Std.Date.Date_t tpep_pickup_date; 
   Std.Date.Time_t tpep_pickup_time;
// STRING19 tpep_dropoff_datetime; 
   Std.Date.Date_t tpep_dropoff_date; 
   Std.Date.Time_t tpep_dropoff_time;
   UNSIGNED1 passenger_count;
// REAL4 trip_distance; 
   DECIMAL5_2 trip_distance;
   UNSIGNED1 ratecodeid;
   STRING1   store_and_fwd_flag; 
   UNSIGNED2 pulocationid; 
   UNSIGNED2 dolocationid; 
   UNSIGNED1 payment_type;
// REAL8 fare_amount; 
   DECIMAL9_2 fare_amount; 
// REAL4 extra;
   DECIMAL5_2 extra;
// REAL4 mta_tax;
   DECIMAL5_2 mta_tax;
// REAL4 tip_amount;
   DECIMAL5_2 tip_amount;
// REAL4 tolls_amount;
   DECIMAL5_2 tolls_amount;
// REAL4 improvement_surcharge;
   DECIMAL3_2 improvement_surcharge;
// REAL8 total_amount;
   DECIMAL9_2 total_amount;
  END;
 EXPORT File := DATASET(CleanFilename,Layout,FLAT);
END;
