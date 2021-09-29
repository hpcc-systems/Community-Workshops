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


  EXPORT myDataE := PROJECT(Bank,ML_Clean(LEFT,COUNTER));
                           

  // Shuffle your data by sorting on the random field
  SHARED myDataES := SORT(myDataE, rnd);
  // Now cut the deck and you have random samples within each set
  // While you're at it, project back to your original format -- we dont need the rnd field anymore
  // Treat first 5000 as training data.  Transform back to the original format.
  EXPORT myTrainData := PROJECT(myDataES[1..5000], ML_Bank);
                                 
  // Treat next 2000 as test data
  EXPORT myTestData  := PROJECT(myDataES[5001..7000], ML_Bank);
                                
END;