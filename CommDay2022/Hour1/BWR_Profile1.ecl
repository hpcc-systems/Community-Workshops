IMPORT $;
ds  := $.File_Yellow.SuperFile;
$.Profile.Func(TABLE(ds,{fld := VendorID}),'VendorID')
+
$.Profile.Func(TABLE(ds,{fld := tpep_pickup_datetime}),'tpep_pickup_datetime')
+ 
$.Profile.Func(TABLE(ds,{fld := tpep_dropoff_datetime}),'tpep_dropoff_datetime')
+
$.Profile.Func(TABLE(ds,{fld := passenger_count}),'passenger_count');
