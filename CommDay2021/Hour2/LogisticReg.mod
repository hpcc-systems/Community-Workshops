//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.BWR_ViewPrepData
IMPORT $,STD;

//Browse raw input data
// OUTPUT($.File_Banking.File,NAMED('Banking'));
// COUNT($.File_Banking.File);
// COUNT($.File_Banking.File(y='0'));
// COUNT($.File_Banking.File(y='1'));

// Profiling the raw data
// STD.DataPatterns.Benford($.File_Banking.File);
// STD.DataPatterns.Profile($.File_Banking.File);

//Browse encoded input data 
// OUTPUT($.Prep01.myDataE,NAMED('EncodedBanking'));
// COUNT($.Prep01.myDataE);

// Browse encoded train data and test data
// OUTPUT($.Prep01.myTrainData,NAMED('TrainData'));
// COUNT($.Prep01.myTrainData);
// OUTPUT($.Prep01.myTestData,NAMED('TestData'));
// COUNT($.Prep01.myTestData);

// Browse converted train and test data
OUTPUT($.Convert02.myIndTrainDataNF,NAMED('IndTrain'));
OUTPUT($.Convert02.myDepTrainDataNF,NAMED('DepTrain'));
OUTPUT($.Convert02.myIndTestDataNF,NAMED('IndTest'));
OUTPUT($.Convert02.myDepTestDataNF,NAMED('DepTest'));

//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.Convert02
IMPORT $;
IMPORT ML_Core;

myTrainData := $.Prep01.myTrainData;
myTestData  := $.Prep01.myTestData;

//Numeric Field Matrix conversion
ML_Core.ToField(myTrainData, myTrainDataNF);
ML_Core.ToField(myTestData, myTestDataNF);
// OUTPUT(myTrainDataNF, NAMED('TrainDataNF'));  //Spot the Numeric Field Matrix conversion
// OUTPUT(myTestDataNF, NAMED('TestDataNF'));  //Spot the Numeric Field Matrix conversion

EXPORT Convert02 := MODULE
  //We have 20 independent fields and the last field (21) is the dependent
  EXPORT myIndTrainDataNF := myTrainDataNF(number < 21); // Number is the field number
  EXPORT myDepTrainDataNF := PROJECT(myTrainDataNF(number = 21), 
                                     TRANSFORM(ML_Core.Types.DiscreteField, 
                                               SELF.number := 1,
                                               SELF := LEFT));
  EXPORT myIndTestDataNF := myTestDataNF(number < 21); // Number is the field number
  EXPORT myDepTestDataNF := PROJECT(myTestDataNF(number = 21), 
                                    TRANSFORM(ML_Core.Types.DiscreteField, 
                                              SELF.number := 1,
                                              SELF := LEFT));
END;


//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.DCTs
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

//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.File_Banking
// The dataset we are using shows direct marketing campaigns (phone calls) of a 
// Portuguese banking institution. The classification goal is to predict whether the client 
// will subscribe (1/0) to a term deposit (variable y).
//https://raw.githubusercontent.com/madmashup/targeted-marketing-predictive-engine/master/banking.csv

EXPORT File_Banking := MODULE
//** = categorical
  EXPORT Layout := RECORD
    STRING age;
    STRING job;            //**
    STRING marital;        //**
    STRING education;      //**
    STRING default;        //** - has credit in default?
    STRING housing;        //** - has housing loan?
    STRING loan;           //** - has personal loan?
    STRING contact;        //** - cellular, telephone
    STRING month;          //** - last contact
    STRING day_of_week;    //**
    STRING duration;       //contact time in seconds
    STRING campaign;       //how many times contacted
    STRING pdays;          //days passed after last contact
    STRING previous;       //previous contacts 
    STRING poutcome;       //previous outcome
    STRING emp_var_rate;   //employment variation rate
    STRING cons_price_idx; //consumer price index
    STRING cons_conf_idx;  //consumer confidence index
    STRING euribor3m;      //euribor 3 month rate
    STRING nr_employed;    //number of employees
    STRING y;              //subscribed? Yes/No - dependent
  END;

  // Related to direct marketing campaigns (phone calls) 
  // of a Portuguese banking institution. The classification goal is to predict 
  // whether the client will subscribe (1/0) to a term deposit (variable y).

  EXPORT File := DATASET('~Tutorial::LogisticRegression::banking',layout,CSV(HEADING(1)));

  EXPORT MLBank := RECORD
   UNSIGNED4 RecID;
  //*****quantitative below:
   UNSIGNED1 age;
   UNSIGNED2 duration;            //contact time in seconds
   UNSIGNED1 campaign;            //how many times contacted
   UNSIGNED2 pdays;               //days passed after last contact
   UNSIGNED1 previous;            //previous contacts 
   DECIMAL4_2 emp_var_rate;       //emplyment variation rate
   DECIMAL4_2 cons_price_idx;     //consumer price index
   DECIMAL4_2 cons_conf_idx;      //consumer confidence index
   DECIMAL4_2 euribor3m;          //euribor 3 month rate
   UNSIGNED2 nr_employed;         //number of employees
  //*****qualitative below
   UNSIGNED1 poutcode;            //previous outcome
   UNSIGNED1 jobcode;        //**
   UNSIGNED1 maritalcode;    //**
   UNSIGNED1 educationcode;  //**
   UNSIGNED1 defaultcode;    //** - has credit in default?
   UNSIGNED1 housingcode;    //** - has housing loan?
   UNSIGNED1 loancode;       //** - has personal loan?
   UNSIGNED1 contactcode;    //** - cellular, telephone
   UNSIGNED1 monthcode;      //** - last contact
   UNSIGNED1 day_of_weekcode;//** 
   UNSIGNED1 y;              //subscribed? Yes/No - dependent data
  END;
END;
//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.Prep01
IMPORT $;

Bank    := $.File_Banking.File;
ML_Bank := $.File_Banking.MLBank;

EXPORT Prep01 := MODULE
  MLBankExt := RECORD(ML_Bank)
    UNSIGNED4 rnd; // A random number
  END;

  // Format the data and assign a random number to each record
  MLBankExt ML_Clean(Bank le, INTEGER Cnt) := TRANSFORM
   SELF.rnd            := RANDOM(); 
   SELF.RECID          := Cnt;
   SELF.age            := (UNSIGNED1)Le.age;
   SELF.Duration       := (INTEGER)Le.Duration;
   SELF.Campaign       := (INTEGER)Le.Campaign;
   SELF.Pdays          := (INTEGER)Le.Pdays;
   SELF.Previous       := (INTEGER)Le.Previous;
   SELF.emp_var_rate   := (DECIMAL)Le.emp_var_rate;
   SELF.cons_price_idx := (DECIMAL)Le.cons_price_idx;
   SELF.cons_conf_idx  := (DECIMAL)Le.cons_conf_idx;
   SELF.euribor3m      := (DECIMAL)Le.euribor3m;
   SELF.nr_employed    := (INTEGER)Le.nr_employed;
   SELF.jobcode        := $.DCTs.MapJob2Code(Le.job);        
   SELF.maritalcode    := $.DCTs.MapMar2Code(Le.Marital);
   SELF.educationcode  := $.DCTs.MapEd2code(Le.Education);  
   SELF.defaultcode    := $.DCTs.MapYN2Code(Le.Default);    
   SELF.housingcode    := $.DCTs.MapYN2Code(Le.Housing);    
   SELF.loancode       := $.DCTs.MapYN2Code(Le.Loan);       
   SELF.contactcode    := IF(Le.Contact = 'cellular',1,2);    
   SELF.monthcode      := $.DCTs.MapMth2Code(Le.Month); 
   SELF.day_of_weekcode := $.DCTs.MapDOW2Code(Le.day_of_week);
   SELF.PoutCode       := $.DCTs.MapPO2Code(Le.POutcome);
   SELF.y              := (UNSIGNED1)Le.Y;
   SELF := Le;
  END;


  EXPORT myDataE := PROJECT(Bank,ML_Clean(LEFT,COUNTER))
                           :PERSIST('~Tutorial::LogisticRegression::XXX::FormattedData');

  // Shuffle your data by sorting on the random field
  SHARED myDataES := SORT(myDataE, rnd);
  // Now cut the deck and you have random samples within each set
  // While you're at it, project back to your original format -- we dont need the rnd field anymore
  // Treat first 5000 as training data.  Transform back to the original format.
  EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Bank)
                               :PERSIST('~Tutorial::LogisticRegression::XXX::Train');  
  // Treat next 2000 as test data
  EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Bank)
                               :PERSIST('~Tutorial::LogisticRegression::XXX::Test'); 
END;
//Import:ecl:Workshops.CommDay2021.Hour2.LogisticReg.Train03
IMPORT LogisticRegression as LR;
IMPORT ML_Core;
IMPORT $;

//Training and Test data
XTrain := $.Convert02.myIndTrainDataNF;
YTrain := $.Convert02.myDepTrainDataNF;
XTest  := $.Convert02.myIndTestDataNF;
YTest  := $.Convert02.myDepTestDataNF;

//Train Logistic Regression Model on Banking data
myLearner := LR.BinomialLogisticRegression();
myModel   := myLearner.getModel(XTrain, YTrain);
	 
//Test Logistic Regression Model on Banking data
MyPredict := myLearner.Classify(myModel, XTest);
OUTPUT(MyPredict, NAMED('PredictedValues'));

//Assess Logistic Regression model on Banking data
MyConfMatrix := LR.Confusion(Ytest,MyPredict);
OUTPUT(MyConfMatrix, NAMED('ConfusionMatrix'));
MyConfAccy := LR.BinomialConfusion(MyConfMatrix);
OUTPUT(MyConfAccy, NAMED('ConfusionAccuracy'));	 
	 
//Utilize AIC (Akaike Information Criterion) for model optimization
MyBeta := LR.ExtractBeta(myModel);
OUTPUT(MyBeta, NAMED('BetaValues'));
MyScores := LR.LogitScore(MyBeta,Xtest);
OUTPUT(MyScores , NAMED('ScoreValues'));
MyDeviance := LR.Deviance_Detail(YTest,MyScores);
OUTPUT(MyDeviance, NAMED('DevianceValues'));
MyAIC := LR.Model_Deviance(MyDeviance,MyBeta);
OUTPUT(MyAIC, NAMED('AIC'));
   

   

   
