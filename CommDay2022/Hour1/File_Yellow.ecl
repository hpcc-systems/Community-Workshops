EXPORT File_Yellow := MODULE
 EXPORT Layout := RECORD
    STRING VendorID;
    STRING tpep_pickup_datetime;
    STRING tpep_dropoff_datetime;
    STRING passenger_count;
    STRING trip_distance;
    STRING RatecodeID;
    STRING store_and_fwd_flag;
    STRING PULocationID;
    STRING DOLocationID;
    STRING payment_type;
    STRING fare_amount;
    STRING extra;
    STRING mta_tax;
    STRING tip_amount;
    STRING tolls_amount;
    STRING improvement_surcharge;
    STRING total_amount;
 END;
 EXPORT File_201701 := DATASET('~dg::yellow_tripdata_2017-01.csv',Layout,CSV(HEADING(1)));
 EXPORT File_201702 := DATASET('~dg::yellow_tripdata_2017-02.csv',Layout,CSV(HEADING(1)));
 EXPORT SuperFile   := DATASET('~dg::yellow_tripdata_superfile',Layout,CSV(HEADING(1)));
END;