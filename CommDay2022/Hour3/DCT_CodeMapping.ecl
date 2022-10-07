IMPORT $.^.Util; //make fnMAC_Txt2Code available

//sample dataset for a selfcontained example
Rec :=  RECORD
  STRING age;
  STRING job;
  STRING marital;
  STRING education;
END;
ds := DATASET([
    {'44', 'blue-collar', 'married', 'basic.4y'}, 
    {'53', 'technician', 'married', 'unknown'}, 
    {'28', 'management', 'single', 'university.degree'}, 
    {'39', 'services', 'married', 'high.school'}, 
    {'55', 'retired', 'married', 'basic.4y'}, 
    {'30', 'management', 'divorced', 'basic.4y'}, 
    {'37', 'blue-collar', 'married', 'basic.4y'}, 
    {'39', 'blue-collar', 'divorced', 'basic.9y'}, 
    {'36', 'admin.', 'married', 'university.degree'}, 
    {'27', 'blue-collar', 'single', 'basic.4y'}, 
    {'34', 'housemaid', 'single', 'university.degree'}, 
    {'41', 'management', 'married', 'university.degree'}, 
    {'55', 'management', 'married', 'university.degree'}, 
    {'33', 'services', 'divorced', 'high.school'}, 
    {'26', 'admin.', 'married', 'high.school'}, 
    {'52', 'services', 'married', 'high.school'}, 
    {'35', 'services', 'married', 'high.school'}, 
    {'27', 'admin.', 'single', 'university.degree'}, 
    {'28', 'blue-collar', 'married', 'basic.9y'}, 
    {'26', 'unemployed', 'single', 'basic.9y'}, 
    {'41', 'unemployed', 'married', 'basic.9y'}, 
    {'35', 'blue-collar', 'single', 'unknown'}, 
    {'40', 'admin.', 'married', 'university.degree'}, 
    {'32', 'technician', 'single', 'professional.course'}, 
    {'41', 'blue-collar', 'married', 'high.school'}, 
    {'34', 'entrepreneur', 'single', 'university.degree'}, 
    {'49', 'technician', 'divorced', 'unknown'}, 
    {'37', 'admin.', 'married', 'high.school'}, 
    {'35', 'blue-collar', 'married', 'basic.6y'}, 
    {'38', 'blue-collar', 'single', 'basic.4y'}, 
    {'47', 'services', 'divorced', 'high.school'}, 
    {'46', 'admin.', 'married', 'university.degree'}, 
    {'27', 'technician', 'married', 'professional.course'}, 
    {'29', 'technician', 'married', 'high.school'}, 
    {'32', 'services', 'divorced', 'basic.9y'}, 
    {'36', 'blue-collar', 'married', 'basic.6y'}, 
    {'29', 'blue-collar', 'married', 'basic.4y'}, 
    {'47', 'technician', 'married', 'high.school'}, 
    {'44', 'blue-collar', 'married', 'basic.4y'}, 
    {'54', 'management', 'married', 'university.degree'}, 
    {'36', 'blue-collar', 'married', 'basic.9y'}, 
    {'42', 'blue-collar', 'married', 'basic.4y'}, 
    {'44', 'blue-collar', 'married', 'basic.4y'}, 
    {'72', 'retired', 'divorced', 'basic.6y'}, 
    {'48', 'blue-collar', 'married', 'basic.9y'}, 
    {'36', 'management', 'married', 'high.school'}, 
    {'35', 'housemaid', 'married', 'basic.4y'}, 
    {'43', 'entrepreneur', 'married', 'basic.6y'}, 
    {'56', 'retired', 'married', 'basic.4y'}, 
    {'42', 'blue-collar', 'married', 'basic.9y'}, 
    {'31', 'admin.', 'single', 'university.degree'}, 
    {'32', 'technician', 'married', 'basic.9y'}, 
    {'33', 'blue-collar', 'married', 'high.school'}, 
    {'31', 'blue-collar', 'married', 'basic.6y'}, 
    {'39', 'management', 'married', 'university.degree'}, 
    {'30', 'blue-collar', 'married', 'high.school'}, 
    {'24', 'management', 'single', 'university.degree'}, 
    {'24', 'admin.', 'married', 'high.school'}, 
    {'38', 'blue-collar', 'married', 'professional.course'}, 
    {'26', 'blue-collar', 'married', 'high.school'}, 
    {'41', 'technician', 'married', 'professional.course'}, 
    {'34', 'admin.', 'married', 'high.school'}, 
    {'30', 'management', 'married', 'university.degree'}, 
    {'37', 'admin.', 'married', 'university.degree'}, 
    {'68', 'retired', 'married', 'basic.4y'}, 
    {'31', 'admin.', 'single', 'high.school'}, 
    {'48', 'technician', 'divorced', 'university.degree'}, 
    {'33', 'technician', 'married', 'professional.course'}, 
    {'59', 'self-employed', 'single', 'university.degree'}, 
    {'44', 'blue-collar', 'married', 'unknown'}, 
    {'28', 'unknown', 'single', 'unknown'}, 
    {'50', 'management', 'married', 'university.degree'}, 
    {'33', 'entrepreneur', 'married', 'university.degree'}, 
    {'45', 'services', 'married', 'professional.course'}, 
    {'40', 'management', 'married', 'university.degree'}, 
    {'45', 'services', 'married', 'professional.course'}, 
    {'43', 'technician', 'divorced', 'university.degree'}, 
    {'54', 'blue-collar', 'married', 'professional.course'}, 
    {'53', 'technician', 'divorced', 'professional.course'}, 
    {'35', 'self-employed', 'single', 'university.degree'}, 
    {'30', 'technician', 'single', 'professional.course'}, 
    {'25', 'technician', 'married', 'professional.course'}, 
    {'35', 'services', 'divorced', 'professional.course'}, 
    {'54', 'admin.', 'married', 'university.degree'}, 
    {'30', 'blue-collar', 'married', 'basic.6y'}, 
    {'38', 'admin.', 'married', 'university.degree'}, 
    {'35', 'admin.', 'married', 'university.degree'}, 
    {'47', 'blue-collar', 'married', 'professional.course'}, 
    {'32', 'blue-collar', 'single', 'high.school'}, 
    {'27', 'blue-collar', 'married', 'basic.9y'}, 
    {'40', 'blue-collar', 'married', 'basic.9y'}, 
    {'31', 'admin.', 'married', 'high.school'}, 
    {'42', 'blue-collar', 'divorced', 'basic.9y'}, 
    {'40', 'blue-collar', 'married', 'basic.6y'}, 
    {'31', 'admin.', 'single', 'high.school'}, 
    {'57', 'technician', 'married', 'basic.4y'}, 
    {'38', 'admin.', 'single', 'high.school'}, 
    {'39', 'services', 'married', 'high.school'}, 
    {'37', 'admin.', 'divorced', 'high.school'}, 
    {'50', 'unemployed', 'married', 'professional.course'}], Rec);

OUTPUT(DS);
//****************************************************

//map strings to codes:
Jobs := Util.fnMAC_Txt2Code(ds,job) : INDEPENDENT, PERSIST('~dg::job_codes');
Mars := Util.fnMAC_Txt2Code(ds,marital) : INDEPENDENT, PERSIST('~dg::marital_codes');
Edus := Util.fnMAC_Txt2Code(ds,education) : INDEPENDENT, PERSIST('~dg::education_codes');
Jobs;Mars;Edus;

//define a DICTIONARY for each field mapping:
JobCodeDCT := DICTIONARY(Jobs,{job => code});
MarCodeDCT := DICTIONARY(Mars,{marital => code});
EduCodeDCT := DICTIONARY(Edus,{education => code});

//then use those DICTIONARYs to map the strings to codes: 
MapRec := RECORD
  STRING age;
  UNSIGNED1 jobcode;
  UNSIGNED1 maritalcode;
  UNSIGNED1 educationcode;
END; 
OutCodes := PROJECT(ds,
                    TRANSFORM(MapRec,
                              SELF.jobcode := JobCodeDCT[LEFT.job].code,
                              SELF.maritalcode := MarCodeDCT[LEFT.marital].code,
                              SELF.educationcode := EduCodeDCT[LEFT.education].code,
                              SELF := LEFT));
                              
OUTPUT(OutCodes);                              




