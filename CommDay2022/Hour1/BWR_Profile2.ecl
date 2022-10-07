IMPORT $, Std;
r  := $.File_Yellow.Layout;
ds := $.File_Yellow.SuperFile;
FileOut := '~File_Yellow::Profile::SuperFile_' + (STRING8)Std.Date.Today();

#DECLARE(xmlrec);
#EXPORT(xmlrec,r); 
OUTPUT(%'xmlrec'%,NAMED('XML_RecStruct'));

LOADXML(%'xmlrec'%,'xmlout');
// #EXPORTXML(xmlout,r);
// using #EXPORTXML instead of #EXPORT 
// would eliminate the need for LOADXML()

#DECLARE(ctr);            //create "ctr" symbol
#SET(ctr,0);              //initialize to 0
#DECLARE(outstr);         //create "outstr" symbol
#FOR (xmlout)             //parse the xml
  #FOR (field)              //for each "Field" tag
    #SET(ctr,%ctr% + 1);      //increment "ctr" symbol
    #IF (%ctr% = 1)           //detect first iteration
                          //and assign initial ECL
                          //code to generate
      #SET(outstr,'$.Profile.Func(TABLE(ds,{fld := ' + %'{@name}'% + '}),\'' + %'{@name}'% + '\')')
    #ELSE        //every other iteration
    //add more ECL code to generate
      #APPEND(outstr,' + \n$.Profile.Func(TABLE(ds, ' + ' {fld := ' + %'{@name}'% + '}),\'' + %'{@name}'% + '\')')
    #END
  #END
#END 

OUTPUT(%'outstr'%,NAMED('ECL_Code'));
//shows the generated ECL 
OUTPUT(%outstr%,,FileOut,NAMED('ProfileInfo'));
//runs the generated ECL
