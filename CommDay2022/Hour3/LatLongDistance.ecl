IMPORT $.^.Util;
Util.LatLong_DMS2DD('35° 5\' 27" N');     //DMS
Util.LatLong_DMS2DD('35° 5.45\'');        //DM
Util.LatLong_DMS2DD('35.09083333333334'); //DD
Util.LatLong_DMS2DD('350527N');           //NUMS
Util.LatLong_DMS2DD('35° 5\' 27" S');     //DMS
Util.LatLong_DMS2DD('-35° 5.45\'');       //DM
Util.LatLong_DMS2DD('-35.09083333333334');//DD
Util.LatLong_DMS2DD('350527S');           //NUMS

//derived from data at https://gist.github.com/erichurst/7882666
DD := DECIMAL9_6; 			//data type redefinition
ZipRec := RECORD
  UNSIGNED1 LocID;
  UNSIGNED3 Zip;
  STRING20 Location;
  STRING20 sLat;
  STRING20 slng;
  DD dLat;
  DD dLng;
END;
Zip := DATASET([{1,11229,
                 'Sheepshead Bay, NY',
                 '40° 36\' 4.6542"',
                 '-73° 56\' 40.1742"',0,0},  
                {2,33434,
                 'Boca Raton, FL',
                 '26° 22\' 57.7632"',
                 '-80° 10\' 1.6962"',0,0},    
                {3,49202,
                 'Jackson, MI',
                 '42° 16\' 1.8438"',
                 '-84° 24\' 39.0594"',0,0}, 
                {4,92067,
                 'Rancho Santa Fe, CA',
                 '33° 1\' 15.2682"',
                 '-117° 11\' 25.2456"',0,0}], 
               ZipRec);

ZipRec PXF(Zip L) := TRANSFORM
  SELF.dLat := (DD)Util.LatLong_DMS2DD(L.sLat),
  SELF.dLng := (DD)Util.LatLong_DMS2DD(L.sLng),
  SELF := L;
END;	

P := PROJECT(Zip,PXF(LEFT));

Jrec := RECORD
  STRING20 Point_A;
  STRING20 Point_B;
  DECIMAL9_4 Distance;
END;

Jrec JXF(ZipRec L, ZipRec R) := TRANSFORM
  SELF.Point_A  := L.Location,
  SELF.Point_B  := R.Location,
  SELF.Distance := Util.DistLatLong(L.dLat,L.dLng,
                                    R.dLat,R.dLng)
END;	
			
J := JOIN(P,P,
          LEFT.LocID < RIGHT.LocID,  //the "<" here matches just the unique pairs, not all commutative pairs (which you would get by making it "<>")
          JXF(LEFT,RIGHT),ALL);				 
OUTPUT(J,NAMED('Distances'));