IMPORT $.^ AS Root;
IMPORT $;
People := Root.File_PeopleAll.People;
OUTPUT(COUNT(People($.PropTaxBeds3 > 0)),NAMED('Q1_265988'));
OUTPUT(COUNT(People($.PropValSmallStreet > 0)),NAMED('Q2_205710'));
OUTPUT(COUNT(People($.PropTaxDataHomeAssess <> '')),NAMED('Q3_256290'));


//AND!!
OUTPUT(People,{$.PropTaxBeds3,$.PropValSmallStreet,$.PropTaxDataHomeAssess,People},NAMED('PeopleEnh'));
