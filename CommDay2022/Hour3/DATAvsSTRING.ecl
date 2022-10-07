IMPORT Std;

//differences in storage for the same logical data
STRING32 S32 := '0AB911267E8C4C389A983B9A10B5FA2B';
DATA16 D16   := X'0AB911267E8C4C389A983B9A10B5FA2B';
OUTPUT(S32,NAMED('S32'));
OUTPUT(D16,NAMED('D16'));

//simple type cast produces wrong result:
 DATA16 CastID := (DATA16)S32;
 OUTPUT(CastID,NAMED('SimpleTypeCast'));

//simple type transfer also wrong result:
 DATA16 XferID := (>DATA16<)S32;
 OUTPUT(XferID,NAMED('SimpleTypeTransfer'));
 
 //simple type transfer that works:
 XferS2D := D'ABCDEFGH';
 OUTPUT(XferS2D,NAMED('SimpleTypeTransfer_2'));
 XferD2S := (>STRING8<)XferS2D;
 OUTPUT(XferD2S,NAMED('SimpleTypeTransfer_3'));
 
DATA16 D16_ID := Std.Str.FromHexPairs(S32);
OUTPUT(D16_ID,NAMED('StrFromHexPairs'));

STRING32 S32_ID := Std.Str.ToHexPairs(D16_ID);
OUTPUT(S32_ID,NAMED('StrToHexPairs'));

//**********************************************	
//you can use it like this with HASHMD5:	
//first store the hashed username and password:
User := 'myname';
Pwd  := 'mypassword';
DATA16 LoginHash := HASHMD5(User,Pwd);

//a simple compare function:
IsLoginMatch(DATA16 StoredHash,STRING32 PassedHash) := PassedHash = STD.Str.ToHexPairs(StoredHash);

//the transmitting side calculates the 32-byte STRING to pass:
PassHash1 := Std.Str.ToHexPairs(HASHMD5('myname','mypassword'));
PassHash2 := Std.Str.ToHexPairs(HASHMD5('mnyame','mypassword'));

//the receiving side compares to see if the "transmitted" HASHMD5 string matches
GoodMatch := IsLoginMatch(LoginHash,PassHash1);
OUTPUT(GoodMatch,NAMED('LoginCompareTrue'));          

BadMatch  := IsLoginMatch(LoginHash,PassHash2);
OUTPUT(BadMatch,NAMED('LoginCompareFalse'));  






 
 

