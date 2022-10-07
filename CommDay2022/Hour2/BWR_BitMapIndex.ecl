IMPORT $.^.Util, Std;
// IMPORT $.^.^.Util, Std;

AnyBit := RANDOM() % 8 + 1; //a random number from 1 to 8:	

//generate a record set with a bitmap
rec := {$.GenDS.File, UNSIGNED1 Bits};
rec XF($.GenDS.File L) := TRANSFORM
  SELF.Bits := RANDOM() % 255 + 1; //any value from 1-255
  SELF := L;
END;	
BitRecs := PROJECT($.GenDS.File,XF(LEFT));
BitRecs;

//define indexes with a bitmap search term and BUILD it
ds1 := BitRecs[.. COUNT(BitRecs)/2];
ds2 := BitRecs[COUNT(BitRecs)/2+1 ..];
BitIDX1 := INDEX(ds1,{Bits},{ds1},'~DG::IDX::Bitmap1');
BitIDX2 := INDEX(ds2,{Bits},{ds2},'~DG::IDX::Bitmap2');
// BUILD(BitIDX1,OVERWRITE);
// BUILD(BitIDX2,OVERWRITE);

//look at the distribution of Bits values:
// SORT(TABLE(BitIDX1,{Bits,Cnt := COUNT(GROUP)},Bits),-Cnt);
// SORT(TABLE(BitIDX2,{Bits,Cnt := COUNT(GROUP)},Bits),-Cnt);



//name the bits for code readability
Sport := ENUM(UNSIGNED1,
              surfer,runner,golfer,skier,
              bowler,tennis,scuba,sailor);	   //sports demographics				 

//simple filter using the Bit().IsSet function
// OUTPUT(BitIDX1(Util.Bit(Sport.skier,Bits).IsSet),
       // ALL,NAMED('Skiers1'));
// OUTPUT(BitIDX2(Util.Bit(Sport.skier,Bits).IsSet),
       // ALL,NAMED('Skiers2'));


// Util.Bits.NumSet(11111110b);  //[254,255]

//simple filter using the Bit().AreSet function
UNSIGNED1 SDS := Util.Bit(Sport.surfer).Bit + 
                 Util.Bit(Sport.scuba).Bit + 
                 Util.Bit(Sport.sailor).Bit; 
// Util.Bits.ShowStr(SDS);
// OUTPUT(BitIDX1(Util.Bit(SDS,Bits).AreSet),ALL,NAMED('Surfer_Diver_Sailors_NonKeyed1')); 
// OUTPUT(BitIDX2(Util.Bit(SDS,Bits).AreSet),ALL,NAMED('Surfer_Diver_Sailors_NonKeyed2')); 

//using a SET to filter so KEYED can be used
// OUTPUT(BitIDX1(KEYED(Bits IN Util.Bits.NumSet(SDS))),ALL,NAMED('Surfer_Diver_Sailors_Keyed1'));
// OUTPUT(BitIDX2(KEYED(Bits IN Util.Bits.NumSet(SDS))),ALL,NAMED('Surfer_Diver_Sailors_Keyed2'));


UNSIGNED1 SS := Util.Bit(Sport.surfer).Bit + 
                Util.Bit(Sport.sailor).Bit; 

//this does NOT work, syntax checks but errors out at runtime:
// J1 := JOIN(BitIDX1,BitIDX2,
           // Util.Bit(SS,LEFT.Bits).AreSet AND 
					  // Util.Bit(SDS,RIGHT.Bits).AreSet,
           // TRANSFORM({UNSIGNED LPat,UNSIGNED RPat,
                      // {BitIDX1} L,{BitIDX2} R},
                     // SELF.L := LEFT,
                     // SELF.R := RIGHT,
                     // SELF.LPat := SS,
                     // SELF.RPat := SDS));
// OUTPUT(J1,ALL,NAMED('JOINed_Surfer_Sailors_NonKeyed'));

//this DOES work:
Lset := Util.Bits.NumSet(SS);
Rset := Util.Bits.NumSet(SDS);
Comma(STRING n) := Std.Str.Find(n,',');
J2 := JOIN(BitIDX1,BitIDX2, 
           KEYED(LEFT.Bits IN Lset AND RIGHT.Bits IN Rset) AND
                 LEFT.Name[1 .. Comma(LEFT.Name)] = RIGHT.Name[1 .. Comma(RIGHT.Name)],
           TRANSFORM({UNSIGNED LPat,UNSIGNED RPat,{BitIDX1} L,{BitIDX2} R},
                      SELF.L := LEFT,
                      SELF.R := RIGHT,
                      SELF.LPat := SS,
                      SELF.RPat := SDS));
COUNT(J2);
OUTPUT(J2,NAMED('JOINed_Surfer_Sailors_Keyed'));
