 IMPORT $;
EXPORT File_PeopleAll := MODULE
 EXPORT Layout_PropTax := RECORD
  $.File_Property.Layout;
  UNSIGNED1 TaxCount;
  DATASET($.File_Taxdata.Layout) TaxRecs{MAXCOUNT(20)};
 END;
 EXPORT Layout := RECORD
  $.File_People.Layout; 
  UNSIGNED1 PropCount;
  DATASET(Layout_PropTax) PropRecs{MAXCOUNT(20)};
 END;  
 SHARED Filename   := '~WKSHP::CD2020::PeoplePropTax';
 EXPORT People     := DATASET(Filename,Layout,THOR);
 EXPORT Property   := People.PropRecs;
 EXPORT Taxdata    := People.PropRecs.TaxRecs;
 EXPORT PeoplePlus := DATASET(Filename,{Layout,UNSIGNED8 RecPos {VIRTUAL(FilePosition)}},THOR);
END;
