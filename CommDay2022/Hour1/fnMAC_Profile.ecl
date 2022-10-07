EXPORT fnMAC_Profile(inds) := FUNCTIONMACRO 
  IMPORT $, Std;
  ds := inds;
  r := RECORDOF(inds);


  #EXPORTXML(xmlout,r);     // eliminates LOADXML()
  #DECLARE(ctr);
  #SET(ctr,0);
  #DECLARE(outstr);
   #FOR (xmlout)
    #FOR (field) 

     #SET(ctr,%ctr% + 1);
      #IF (%ctr% = 1)     //detect first iteration
      // and assign initial ECL
      // code to generate:
       #SET(outstr,'$.Profile.Func(TABLE(ds,{fld := ' + %'{@name}'% + '}),\'' + %'{@name}'% + '\')')
      #ELSE      //every other iteration
      //add more ECL code to generate
       #APPEND(outstr,' + \n$.Profile.Func(TABLE(ds, ' + '{fld := ' + %'{@name}'% + '}),\'' + %'{@name}'% + '\')')
      #END
    #END
   #END
  // RETURN %'outstr'%;  //a good way to test
  RETURN %outstr%; 
ENDMACRO;
