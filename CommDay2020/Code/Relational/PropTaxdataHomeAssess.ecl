IMPORT $.^ AS Root;
IMPORT $;
Property := Root.File_PeopleAll.Property;
TaxData  := Root.File_PeopleAll.Taxdata;
PropYear  := IF($.IsValidYear(Property.Year_Acquired),
                              Property.Year_Acquired,
                              Property.Year_built);
PropValue := IF($.IsValidAmount(Property.Total_value),
                                Property.Total_value,
                                Property.Assessed_value);
ValidProperty := Property($.IsValidYear(PropYear),
                          $.IsValidAmount(PropValue),
                          Apt='');
SortedProperty := SORT(ValidProperty,-PropYear,-PropValue);
ValidTaxdata   := Taxdata($.IsValidYear(Tax_year),
                          $.IsValidAmount(Assd_total_val));
															 
SortedTaxdata  := SORT(ValidTaxdata,-Tax_year);
EXPORT STRING8 PropTaxDataHomeAssess :=
                      IF(NOT EXISTS(SortedProperty),
                         '',
                         EVALUATE(SortedProperty[1],
                                  IF(NOT EXISTS(SortedTaxdata),
                                     '',
                                     (STRING8)SortedTaxdata[1].Assd_total_val)));
																	 																	 
																		 
