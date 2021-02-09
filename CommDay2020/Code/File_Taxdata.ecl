EXPORT File_Taxdata := MODULE
EXPORT Layout :=  RECORD
    INTEGER8  propertyid;
    STRING4   document_year;
    UNSIGNED4 total_val_calc;
    UNSIGNED4 land_val_calc;
    UNSIGNED4 improvement_value_calc;
    UNSIGNED4 assd_total_val;
    UNSIGNED4 tax_amount;
    UNSIGNED4 mkt_total_val;
    UNSIGNED4 mkt_land_val;
    UNSIGNED4 mkt_improvement_val;
    UNSIGNED4 tax_year;
    UNSIGNED4 land_square_footage;
    UNSIGNED4 adjusted_gross_square_feet;
    UNSIGNED4 living_square_feet;
    UNSIGNED2 bedrooms;
    UNSIGNED2 full_baths;
    UNSIGNED2 half_baths;
    UNSIGNED2 stories_number;
   END;
	 
EXPORT File :=	DATASET('~WKSHP::CD2020::taxdata',Layout,THOR);
   END; 

