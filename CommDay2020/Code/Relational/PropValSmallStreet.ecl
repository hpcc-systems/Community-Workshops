IMPORT $.^ AS Root;
IMPORT $;
Property := Root.File_PeopleAll.Property;
Total    := Root.File_PeopleAll.Property.Total_value;
Assessed := Root.File_PeopleAll.Property.Assessed_value; 
IsSmallStreet := Property.StreetType IN ['CT','LN','WAY','CIR','PL','TRL'];
HighValue := IF($.IsValidAmount(Total) AND
                $.IsValidAmount(Assessed),
                 IF(Total > Assessed,Total,Assessed),
                 IF($.IsValidAmount(Total),Total,Assessed));
										
SmallProperties := Property(IsSmallStreet AND $.IsValidAmount(HighValue));
EXPORT PropValSmallStreet := IF(NOT EXISTS(SmallProperties),
                                -9,
                                SUM(SmallProperties,HighValue));
