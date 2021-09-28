// The dataset we are using contains ficticious information from properties. 
// The regression goal is to train a model that can predict property prices.
// The raw dataset can be downloaded from our online ECL Training Advanced ECL (part1) class:
// https://learn.lexisnexis.com/Activity/1102# (OnlineProperty)

EXPORT File_Property := MODULE
  EXPORT Layout := RECORD
   UNSIGNED8 personid;
   INTEGER8  propertyid;
   STRING10  house_number;
   STRING10  house_number_suffix;
   STRING2   predir;
   STRING30  street;
   STRING5   streettype;
   STRING2   postdir;
   STRING6   apt;
   STRING40  city;
   STRING2   state;
   STRING5   zip;
   UNSIGNED4 total_value;
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
  END;
  EXPORT File := DATASET('~Tutorial::BoostForest::Property',Layout,THOR);
 
 //New record structure for training the property price model  
	EXPORT MLProp := RECORD
   UNSIGNED8 PropertyID; //identifier - required for LearningTrees NF
   UNSIGNED3 zip;				 //Categorical independent variable - need to be converted to a numerical value
   UNSIGNED4 assessed_value;
   UNSIGNED2 year_acquired;
   UNSIGNED4 land_square_footage;
   UNSIGNED4 living_square_feet;
   UNSIGNED2 bedrooms;
   UNSIGNED2 full_baths;
   UNSIGNED2 half_baths;
   UNSIGNED2 year_built;
   UNSIGNED4 total_value; //Dependent Variable - what we are trying to predict
 END;
 
 //New record structure for training multiple property price models using Myriad Interface
 EXPORT MLPropMI := RECORD
  MLProp;
  UNSIGNED4 wi_id;   //work-item id for Myriad Interface
END;
END;
