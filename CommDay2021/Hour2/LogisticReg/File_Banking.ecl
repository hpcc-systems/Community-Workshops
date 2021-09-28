// The dataset we are using shows direct marketing campaigns (phone calls) of a 
// Portuguese banking institution. The classification goal is to predict whether the client 
// will subscribe (1/0) to a term deposit (variable y).
// https://archive.ics.uci.edu/ml/datasets/bank+marketing (bank-additional-full.csv)

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

  EXPORT File := DATASET('~Tutorial::LogisticRegression::banking',layout,CSV(HEADING(1)));

  //New record structure for training the client subscription model
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