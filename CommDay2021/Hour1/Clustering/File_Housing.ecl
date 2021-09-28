// The dataset we are using contains publicly available information from properties of the City of São Paulo, Brazil. 
// The clustering goal is to generate clusters of properties sharing similar physical attributes.
// The attributes selected for clustering are utilized to calculate the municipal property taxes:
// https://web1.sf.prefeitura.sp.gov.br/CartelaIPTU/  
// The raw dataset can be downloaded from:
// http://geosampa.prefeitura.sp.gov.br/PaginasPublicas/_SBC.aspx (Cadastro > IPTU > IPTU_2019)

EXPORT File_Housing := MODULE
  EXPORT Layout := RECORD
		STRING numero_do_contribuinte;
		STRING ano_do_exercicio;
		STRING numero_da_nl;
		STRING data_do_cadastramento;
		STRING tipo_de_contribuinte_1;
		STRING cpf_cnpj_do_contribuinte_1;
		STRING nome_do_contribuinte_1;
		STRING tipo_de_contribuinte_2;
		STRING cpf_cnpj_do_contribuinte_2;
		STRING nome_do_contribuinte_2;
		STRING numero_do_condominio;
		STRING codlog_do_imovel;
		STRING nome_de_logradouro_do_imovel;
		STRING numero_do_imovel;
		STRING complemento_do_imovel;
		STRING bairro_do_imovel;
		STRING referencia_do_imovel;
		STRING cep_do_imovel;
		STRING quantidade_de_esquinas_frentes;
		STRING fracao_ideal;
		STRING area_do_terreno;
		STRING area_construida;
		STRING area_ocupada;
		STRING valor_do_m2_do_terreno;
		STRING valor_do_m2_de_construcao;
		STRING ano_da_construcao_corrigido;
		STRING quantidade_de_pavimentos;
		STRING testada_para_calculo;
		STRING tipo_de_uso_do_imovel;
		STRING tipo_de_padrao_da_construcao;
		STRING tipo_de_terreno;
		STRING fator_de_obsolescencia;
		STRING ano_de_inicio_da_vida_do_contribuinte;
		STRING mes_de_inicio_da_vida_do_contribuinte;
		STRING fase_do_contribuinte;
		STRING zona;
		STRING profundidade_eq;
		STRING fatordeprof;
		STRING condominio;
		STRING fator_terreno;
		STRING area_exc;
		STRING construcao;
		STRING terreno;
		STRING excesso;
  END;

  EXPORT File:=DATASET('~Tutorial::Clustering::Housing',Layout,CSV(HEADING(1)));
 
 //New record structure for the property attributes that will be clustered
	EXPORT MLHousing := RECORD
	  //REAL field types will be standardized for clustering
		REAL NumberOfFronts;				// Number of fronts from the property
		REAL LandSquareFootage;     // Square footage from the property land
		REAL LivingSquareFootage;		// Square footage from the property living areas
		REAL BuildingSquareFootage; // Square footage from the property building
		REAL YearBuilt;             // Year that property was built
		REAL NumberOfFloors;        // Number of floors from the property
		REAL FrontLinearFeet;       // Front linear feet from the property
		REAL CityZone;              // City zone where the property is located
		REAL CondominiumAdj;        // Adjustment factor if the property is located in a condo
		REAL LandExcess;            // Property land that is not used for living
		REAL BuildingValue;         // Assessed value from the property building
		REAL LandValue;             // Assessed value from the property land
		REAL ExcessValue;           // Assessed value from the property land excess
		//Non-REAL field types will not be used for clustering
		UNSIGNED8 PropertyID;       // Unique Id of the property
		UNSIGNED4 ZipCode;          // Zipcode of the property
	END;
END;