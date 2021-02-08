IMPORT $.^ AS Root;
IMPORT $;
STRING10  house_number_key := '':STORED('House_Number',FORMAT(SEQUENCE(1)));
STRING10  h_n_suffix       := '':STORED('HN_Suffix',FORMAT(SEQUENCE(2)));
STRING2   predir_key       := '':STORED('Pre_Direction',FORMAT(SEQUENCE(3)));
STRING30  street_key       := '':STORED('Street',FORMAT(SEQUENCE(4)));
STRING5   streettype_key   := '':STORED('Type',FORMAT(SEQUENCE(5)));
STRING2   postdir_key      := '':STORED('Post_Direction',FORMAT(SEQUENCE(6)));
STRING6   apt_key          := '':STORED('Apartment_Number',FORMAT(SEQUENCE(7)));
STRING40  city_key         := '':STORED('City',FORMAT(SEQUENCE(8)));
STRING2   state_key        := '':STORED('State',FORMAT(SEQUENCE(9)));
STRING5   zip_key          := '':STORED('Zip',FORMAT(SEQUENCE(10)));
GetPerson := JOIN($.IDX.PropPayIDX(house_number_key = '' OR TRIM(house_number,ALL) = TRIM(house_number_key,ALL), //Right Index
                                   h_n_suffix = '' OR house_number_suffix=h_n_suffix,
                                   predir_key = '' OR predir=predir_key,
                                   street_key = '' OR street=street_key,
                                   streettype_key = '' OR streettype=streettype_key,
                                   postdir_key = '' OR postdir=postdir_key,
                                   apt_key = '' OR apt=apt_key,
                                   city_key = '' OR city=city_key,
                                   state_key = '' OR state=state_key,
                                   zip_key = '' OR zip=zip_key),
													$.IDX.PeoplePayID,
                 LEFT.PersonID = RIGHT.ID,
													TRANSFORM(RIGHT));
CHOOSEN(GetPerson,20);																	 
