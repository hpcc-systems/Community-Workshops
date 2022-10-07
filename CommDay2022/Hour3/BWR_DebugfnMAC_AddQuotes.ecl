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

$.fnMAC_AddQuotes(allPeople);