// Data Dictionary MODULE for label enconding of the categorical variables

EXPORT DCTs := MODULE
 EXPORT Ed_DS :=
  DATASET([
    {'university.degree',1}, 
    {'high.school',2}, 
    {'basic.9y',3}, 
    {'professional.course',4}, 
    {'basic.4y',3}, 
    {'basic.6y',3}, 
    {'unknown',5}, 
    {'illiterate',6}], {STRING18 education,UNSIGNED1 edcode});
 EXPORT YN_DS :=
   DATASET([
    {'yes',1}, 
    {'no',2}, 
    {'unknown',3}], {STRING7 choice,UNSIGNED1 yncode});
	EXPORT Job_DS :=
  dataset([
    {'admin.', 1}, 
    {'blue-collar', 2}, 
    {'entrepreneur', 3}, 
    {'housemaid', 4}, 
    {'management', 5}, 
    {'retired', 6}, 
    {'self-employed', 7}, 
    {'services', 8}, 
    {'student', 9}, 
    {'technician', 10}, 
    {'unemployed', 11}, 
    {'unknown', 12}], {STRING13 job,UNSIGNED1 jobcode});	
	EXPORT Mth_DS :=
  dataset([
    {'jan', 1}, 
    {'feb', 2}, 
    {'apr', 4}, 
    {'aug', 8}, 
    {'dec', 12}, 
    {'jul', 7}, 
    {'jun', 6}, 
    {'mar', 3}, 
    {'may', 5}, 
    {'nov', 11}, 
    {'oct', 10}, 
    {'sep', 9}], {STRING3 mon,UNSIGNED1 mcode});
	EXPORT DOW_DS :=
  dataset([
    {'sun', 1}, 
    {'mon', 2}, 
    {'tue', 3}, 
    {'wed', 4}, 
    {'thu', 5}, 
    {'fri', 6}, 
    {'sat', 7}],{STRING3 dow,UNSIGNED1 dowcode});		
EXPORT Marital_DS :=
  dataset([
    {'divorced', 3}, 
    {'married', 1}, 
    {'single', 2}, 
    {'unknown', 4}], {STRING8 marital,UNSIGNED1 mtlcode});
EXPORT POut_DS :=
  dataset([
    {'nonexistant', 1}, 
    {'failure', 2}, 
    {'success', 3}],{STRING11 pout,UNSIGNED1 poutcode});		

//************************************************
EXPORT EdDCT  := DICTIONARY(Ed_DS,{Education => EdCode});
EXPORT MapEd2Code(STRING Education) := EdDCT[Education].EdCode;
EXPORT YNDCT  := DICTIONARY(YN_DS,{Choice => YNCode});
EXPORT MapYN2Code(STRING Choice) := YNDCT[Choice].YNCode;
EXPORT JobDCT := DICTIONARY(Job_DS,{Job => JobCode});
EXPORT MapJob2Code(STRING Job) := JobDCT[Job].JobCode;
EXPORT MthDCT := DICTIONARY(Mth_DS,{Mon => MCode});
EXPORT MapMth2Code(STRING Mon) := MthDCT[Mon].MCode;
EXPORT DOWDCT := DICTIONARY(DOW_DS,{DOW => DOWCode});
EXPORT MapDOW2Code(STRING DOW) := DOWDCT[DOW].DOWCode;
EXPORT MarDCT := DICTIONARY(Marital_DS,{marital => mtlCode});
EXPORT MapMar2Code(STRING Marital) := MarDCT[Marital].mtlCode;
EXPORT PODCT  := DICTIONARY(POut_DS,{pout => PoutCode});
EXPORT MapPO2Code(STRING POut) := PODCT[POut].POutCode;

END;
