EXPORT DistLatLong(REAL inLat1, REAL inLon1, REAL inLat2, REAL inLon2,BOOLEAN km=FALSE) :=  FUNCTION
 Pi := 3.141592653589793;
 RadInDeg := Pi/180;
 Deg2Rad(REAL deg) := deg * RadInDeg;
 R := IF(km,6373.0,3959.0);

 lat1 := Deg2Rad(inLat1);
 lon1 := Deg2Rad(inLon1);
 lat2 := Deg2Rad(inLat2);
 lon2 := Deg2Rad(inLon2);

 dlon := lon2 - lon1;
 dlat := lat2 - lat1;

 a := POWER(SIN(dlat / 2),2) + COS(lat1) * COS(lat2) * POWER(SIN(dlon / 2),2);
 c := 2 * ATAN2(SQRT(a), SQRT(1 - a)); RETURN R * c;
END; 
