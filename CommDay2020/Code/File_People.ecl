EXPORT File_People := MODULE
EXPORT Layout := RECORD
  UNSIGNED8 ID;
  STRING15  FirstName;
  STRING25  LastName;
  STRING15  MiddleName;
  STRING2   NameSuffix;
  STRING8   FileDate;
  STRING1   Gender;
  STRING8   BirthDate;
  END;
EXPORT File := DATASET('~WKSHP::CD2020::People',Layout,THOR);
END;
