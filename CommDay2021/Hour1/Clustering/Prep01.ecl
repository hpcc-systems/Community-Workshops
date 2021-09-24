IMPORT $,STD;

Housing    := $.File_Housing.File;
ML_Housing := $.File_Housing.MLHousing;

EXPORT Prep01 := MODULE
  EXPORT MLHousExt := RECORD(ML_Housing)
    UNSIGNED4 rnd; // A random number
	END;
	
 // Format the data and assign a random number to each record
 MLHousExt ML_Clean (Housing Le) := TRANSFORM
   SELF.rnd                   := RANDOM();
	 SELF.NumberOfFronts        := (REAL)Le.quantidade_de_esquinas_frentes;
	 SELF.LandSquareFootage     := (REAL)Le.area_do_terreno;
	 SELF.LivingSquareFootage   := (REAL)Le.area_construida;
	 SELF.BuildingSquareFootage := (REAL)Le.area_ocupada;
	 SELF.YearBuilt             := (REAL)Le.ano_da_construcao_corrigido;
	 SELF.NumberOfFloors        := (REAL)Le.quantidade_de_pavimentos;
	 SELF.FrontLinearFeet       := (REAL)Le.testada_para_calculo;
	 SELF.CityZone              := (REAL)MAP(Le.zona='1SZU'=>1,Le.zona='2SZU'=>2,Le.zona='3SZU'=>3,0);
	 SELF.CondominiumAdj        := (REAL)IF(Le.condominio <>'1',1,0),;
	 SELF.LandExcess            := (REAL)Le.area_exc;
	 SELF.BuildingValue         := (REAL)Le.construcao;
	 SELF.LandValue             := (REAL)Le.terreno;
	 SELF.ExcessValue           := (REAL)Le.excesso;
	 SELF.PropertyID            := (UNSIGNED8)STD.Str.FindReplace(Le.numero_do_contribuinte,'-','');;
	 SELF.ZipCode               := (UNSIGNED4)STD.Str.FindReplace(Le.cep_do_imovel,'-','');
	END;

  EXPORT myDataE := PROJECT(Housing, ML_Clean(LEFT));
	                     
  // Shuffle your data by sorting on the random field
  SHARED myDataES := SORT(myDataE, rnd);
  // Now cut the deck and you have random samples
  // While you're at it, project back to your original format -- we dont need the rnd field anymore
  // Treat first 5000 as training data.  Transform back to the original format.
  EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Housing);
                              
END;