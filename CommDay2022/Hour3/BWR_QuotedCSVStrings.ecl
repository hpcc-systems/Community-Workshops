IMPORT $;
Layout_Person := RECORD
 UNSIGNED1 PersonID;
 STRING15  name;
 STRING25  Address;
END;
allPeople := DATASET([{1,'Fred Smith','1234 Avenue 1'},
                      {2,'Blow,Joe','2345 Avenue 2'},
                      {3,'Smith, Jane','#12, Avenue 4'}],
                      Layout_Person);


OUTPUT(AllPeople,,'~dg::csv_quotes1.csv', CSV(QUOTE('"')),OVERWRITE);

OUTPUT($.fnMAC_AddQuotes(allPeople),,'~dg::csv_quotes2.csv',CSV,OVERWRITE);


// The #EXPORTXML generates an XML string from the r RECORD structure and into the xmlout Template symbol, which looks like this: 

/* <Data>
   <Field ecltype="unsigned1"
          label="personid"
          name="personid"
          position="0"
          rawtype="65793"
          size="1"
          type="unsigned"/>
   <Field ecltype="string15"
          label="name"
          name="name"
          position="1"
          rawtype="983044"
          size="15"
          type="string"/>
   <Field ecltype="string25"
          label="address"
          name="address"
          position="2"
          rawtype="1638404"
          size="25"
          type="string"/>
   </Data> 
*/