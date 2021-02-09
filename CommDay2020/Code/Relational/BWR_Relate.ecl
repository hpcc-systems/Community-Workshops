IMPORT $.^ AS Root;
People    := Root.File_People;
Property  := Root.File_Property;
TaxData   := Root.File_Taxdata;
PropTax   := Root.File_PeopleAll.Layout_PropTax;
PeopleAll := Root.File_PeopleAll.Layout;
//Step 1: Denorm Property and Taxdata
PropTax ParentMove(Property.Layout Le) := TRANSFORM
  SELF.TaxCount := 0;
  SELF.TaxRecs  := [];
  SELF := Le;
END;
PropParent := PROJECT(Property.File, ParentMove(LEFT));
PropTax ChildMove(PropTax Le, Taxdata.Layout Ri, INTEGER Cnt):=TRANSFORM
  SELF.TaxCount := Cnt;
  SELF.TaxRecs  := Le.TaxRecs + Ri;
  SELF := Le;
END;
PropTaxFile := DENORMALIZE(PropParent,
                           TaxData.File,
                           LEFT.propertyid = RIGHT.propertyid,
                           ChildMove(LEFT,RIGHT,COUNTER))
                           :PERSIST('~WkSHP::CD2020::PERSIST::PropTax');
OUTPUT(PropTaxFile,NAMED('DenormPropTax'));
//Step 2: Denorm People to Property/Taxdata (PropTaxFile):
PeopleAll InitParent(People.Layout Le) := TRANSFORM
  SELF.PropCount := 0;
  SELF.PropRecs  := [];
  SELF := Le;
END;
ParentOnly := PROJECT(People.File, InitParent(LEFT));
PeopleAll ChildMove2(PeopleAll Le, 
                     PropTax Ri, 
                     INTEGER Cnt):=TRANSFORM
  SELF.PropCount := Cnt;
  SELF.PropRecs  := Le.PropRecs + Ri;
  SELF := Le;
END;
File := DENORMALIZE(ParentOnly, 
                    PropTaxFile,
                    LEFT.id = RIGHT.personid,
                    ChildMove2(LEFT,RIGHT,COUNTER))
													  :PERSIST('~WkSHP::CD2020::PERSIST::PeopleAll');
OUTPUT(File,,'~WKSHP::CD2020::PeoplePropTax',OVERWRITE,NAMED('PeoplePropTax'));
