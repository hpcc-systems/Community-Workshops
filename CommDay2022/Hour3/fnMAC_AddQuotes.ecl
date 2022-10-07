/**
 * Surrounds all string field values with double quotes (")
 * to produce a new record set to write out as a CSV file.
 *
 * @param inds          The dataset to add quotes to.
 * @return              A record set of the new records with quotes around strings.
 */
EXPORT fnMAC_AddQuotes(inds) := FUNCTIONMACRO
 AddQuotes(STRING s) := '"' + TRIM(s) + '"'; 
 r	:= RECORDOF(inds);
 #EXPORTXML(xmlout,r);
//create reccstr and projstr symbols
#DECLARE(recstr);    //generated RECORD structure
#DECLARE(projstr);  //generated PROJECT code
//initialize the symbols
#SET(recstr, '\nrec := RECORD\n');
#SET(projstr,'\nres := PROJECT(' + #TEXT(inds) + ',TRANSFORM(rec,\n');

#FOR (xmlout)             //parse the xml
 #FOR (field)             //for each "field" tag
  #IF (%'{@type}'% = 'string')
   #APPEND(recstr,' STRING ' + %'{@name}'% + ';\n');
   #APPEND(projstr,'  SELF.' + %'{@name}'% + ' := AddQuotes(LEFT.' + %'{@name}'% + '),\n');
  #ELSE 
   #APPEND(recstr,' ' + %'{@type}'% + %'{@size}'% + ' ' + %'{@name}'% + ';\n');
  #END
 #END
#END

//finish off the code to generate
#APPEND(recstr, 'END;\n')
#APPEND(Projstr, '  SELF := LEFT));\n')

//output generated code for testing/debugging
// RETURN   %'recstr'% + %'projstr'%;

//or generate the code
//and run it to return the result
 %recstr%;
 %projstr%;
 RETURN res;
ENDMACRO;
