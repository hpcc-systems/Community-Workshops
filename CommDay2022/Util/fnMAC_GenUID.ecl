/**
 * Generates unique record identifiers, based on a seed value
 * stored as a superfile name
 *
 * @param ds          The dataset to uniquely number.
 * @param prefix      The "starts with" of the superfile name 
 *                    that ends with the appended seed value.
 *                    The first character must be a "~" (tilde).
 * @param UID         The name of the unique identifier field to add.
 * @return            The input dataset with UID field added.
 */
EXPORT fnMAC_GenUID(ds, prefix, UID) := FUNCTIONMACRO
	IMPORT Std;    //inside so it's part of the 	generated code

	//get the starting point number (stored in a superfile name):
	Prelen    := LENGTH(prefix);
	// FileList  := NOTHOR(STD.File.LogicalFileList(prefix[2..] + '*',FALSE,TRUE));//superfiles only
	FileList  := STD.File.LogicalFileList(prefix[2..] + '*');//superfiles only
	FileCount := COUNT(FileList);
	start     := (UNSIGNED)FileList[FileCount].name[PreLen..];
  // start := 0; //test

	//set up for numbering recs
	NodeID := Std.system.Thorlib.Node()+1; //zero-based, so add 1
	NextRec(UNSIGNED C) := NodeID + ((C-1) * CLUSTERSIZE);
				//For a 3-node cluster, this expression numbers recs like this:
				// Node 1   Node 2   Node 3
				//   1        2        3
				//   4        5        6
				//   7                 9  -- assuming 8 records and Node 2 has only 2

	//and numbering the recs:
	OutRec := RECORD
		UNSIGNED8 UID;
		RECORDOF(ds);
	END;
	RetDS := PROJECT(ds,
                   TRANSFORM(OutRec, 
                             SELF.UID := start + NextRec(COUNTER),
                             SELF := LEFT),
                   LOCAL);

	//retain the last number used in superfile name (stored in DFU metadata, only)										
	EndNbr := MAX(RetDS,UID);												 
	WriteEndNbr := STD.File.CreateSuperFile(prefix + (STRING)EndNbr);  

	// Remove the Oldest UID file 
	KeepFiles := 2;      //keeps 3, two prior and the new one 
	RemoveOldUIDfile := IF(FileCount > KeepFiles,
                         STD.File.DeleteSuperFile('~'+FileList[1].name));  

	// RETURN WHEN(RetDS,NOTHOR(PARALLEL(WriteEndNbr,RemoveOldUIDfile)));
	RETURN WHEN(RetDS,PARALLEL(WriteEndNbr,RemoveOldUIDfile));
ENDMACRO;
