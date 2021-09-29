IMPORT STD;
EXPORT File_Image := MODULE
 EXPORT imageRecord := RECORD
  STRING filename;
  DATA   image;   
//first 4 bytes contain the length of the image data
  UNSIGNED8  RecPos{virtual(fileposition)};
 END;
 EXPORT imageData := DATASET('~imagedb::tutorialGNNEx1',imageRecord,FLAT);
 //Add RecID and Dependent Data
 EXPORT imageRecordPlus := RECORD
   UNSIGNED1 RecID; 
   UNSIGNED1 YType;
   imageRecord;
 END;
 
  EXPORT mytraindata := PROJECT(imageData[1..5]+imageData[9..12], 
	                                 TRANSFORM(imageRecordPlus,
	                                           SELF.RecID := COUNTER,
																									           SELF.YType := IF(STD.STR.Find(LEFT.filename,'dog')<> 0,1,0),;
																															   SELF.Image := LEFT.IMAGE[55..],//was 51
																																  SELF := LEFT));
																																	
	 EXPORT mytestdata := PROJECT(imageData[6..7]+imagedata[13..14], 
	                                 TRANSFORM(imageRecordPlus,
	                                           SELF.RecID := COUNTER,
																									           SELF.YType := IF(STD.STR.Find(LEFT.filename,'dog')<> 0,1,0),;
																															   SELF.Image := LEFT.IMAGE[55..],//was 51
																																  SELF := LEFT));																																
																																		 
END;