IMPORT $.^.Util;
P1  :=  'Plagiarism  should  be  avoided  for  a  '  +
        'variety  of  reasons.';
P2  :=  'For  one,  it\'s  dishonest.';
P3  :=  'Put  simply,  presenting  another  '  +
        'writer\'s  work  as  your  own  is  lying.';
P4  :=  P1  +  P2  +  P3;
P5  :=  P1  +  P3;
Util.CosineSimilarity(P1,P1);            //1.0
Util.CosineSimilarity(P1,P1,TRUE,TRUE);  //1.0
Util.CosineSimilarity(P1,P2);            //0.0
Util.CosineSimilarity(P4,P5);            //0.912870929175277

