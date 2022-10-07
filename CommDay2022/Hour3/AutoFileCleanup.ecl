/* Deletes, or sets for automatic deletion, logical files.
 *
 * @param WhichMethod   An integer specifying which method to use:
 *                        1 = set EXPIRE for all files
 *                        2 = set EXPIRE for all files not accessed in the Expiry number of days
 *                        3 = delete all files
 *                        4 = delete all files not accessed in the Expiry number of days
 * @param FilePattern   A standard file pattern using wildcards (? and *) to specify which file to operate on.
 * @param Expiry        A positive integer specifying the number of days to set the EXPIRE option.
 * @return              A record set containing the names of the files deleted or set to EXPIRE.
 */

IMPORT Std;
EXPORT AutoFileCleanup(WhichMethod,
                       STRING FilePattern,
                       Expiry=1) := FUNCTION

  MethodCheck := IF(WhichMethod NOT IN [1,2,3,4], 
                    FAIL('AutoFileCleanup - method out of range'));
  ExpiryCheck := IF(Expiry < 0, 
                    FAIL('AutoFileCleanup - expiry not positive'));

  list := Std.File.LogicalFileList(FilePattern);

	//Simple way: set EXPIRE for all files meeting the FilePattern
  SetExpiryAll := APPLY(list,Std.File.SetExpireDays('~'+list.name,Expiry));

	//Manual ways:
	//determine which files are "too old"
  BOOLEAN IsTooOld(STRING10 d) := FUNCTION
    Cutoff   := 
      Std.Date.FromJulianDate(Std.Date.Today())-Expiry;
    ThisDate := Std.Date.FromStringToDate(d,'%Y-%m-%d');
    ThisDays := Std.Date.FromJulianDate(ThisDate); 
    RETURN ThisDays <= Cutoff;
  END;
	
	//get the last access date/time for each file
  OutRec := RECORD
    STRING name;
    STRING10 accessed; //only the date is important for this
  END;
  OutRec XF(list f) := TRANSFORM
    SELF.name := '~' + f.name;  
    SELF.accessed := 
      Std.File.GetLogicalFileAttribute(SELF.name,'accessed');//'YYYY-MM-DD' return format 
  END; 
  accesslist := PROJECT(list,XF(LEFT));
  OldFiles := accesslist(IsTooOld(accessed));
	
	//Set old files to expire: 
  SetExpiryOld := APPLY(OldFiles,Std.File.SetExpireDays(OldFiles.name,Expiry));

	//Delete Now: delete them straight away
  DeleteAll := APPLY(list,Std.File.DeleteLogicalFile('~'+list.name));

  DeleteOld := APPLY(OldFiles,Std.File.DeleteLogicalFile(OldFiles.name));

  //can't use CHOOSE because it doesn't support actions, so CASE is best
  Action := NOTHOR(CASE(WhichMethod,
                        1 => SetExpiryAll,
                        2 => SetExpiryOld,
                        3 => DeleteAll,
                        DeleteOld));
  AcFile := NOTHOR(IF(WhichMethod % 2 = 1,
                      accesslist,OldFiles));

  SetTxt := ['Nothing to Clean Up!',
             'Files Set to EXPIRE:',
             'Files Deleted:'];		
  FirstRec(C) := DATASET([{SetTxt[C],''}],OutRec);					 

  Files  := MAP(NOT EXISTS(AcFile) => FirstRec(1),  
                WhichMethod IN [1,3] => FirstRec(2) + AcFile,
	              FirstRec(3) + AcFile);
								
  RETURN WHEN(Files,Action);
END;