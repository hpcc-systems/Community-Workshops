IMPORT Std; 
EXPORT CosineSimilarity(STRING L, STRING R, BOOLEAN nocase=FALSE, BOOLEAN nojunk=FALSE) := FUNCTION
 CL := IF(nocase,Std.Str.toUppercase(L),L);
 CR := IF(nocase,Std.Str.toUppercase(R),R);
 Punct := '.?!,;:()[]{}"';
 WL := Std.Str.SubstituteIncluded(CL,Punct,' ');
 WR := Std.Str.SubstituteIncluded(CR,Punct,' ');
 Jstr  := 'the be to of and a in I it for' +
          'The Be To Of And A In It For';
 JstrU := Std.Str.toUppercase(Jstr);
 Jset  := Std.Str.SplitWords(IF(nocase,JstrU,Jstr),' ');
 SL :=  Std.Str.SplitWords(WL,' ');
 SR :=  Std.Str.SplitWords(WR,' ');
 WordRec  :=  {STRING  Word}; 
 DL  :=  IF(nojunk,
            DATASET(SL,WordRec)(Word  NOT  IN  Jset),
            DATASET(SL,WordRec));
 DR  :=  IF(nojunk,
            DATASET(SR,WordRec)(Word  NOT  IN  Jset),
            DATASET(SR,WordRec));

 HashWordRec(STRING  word) := RECORD
  UNSIGNED8  hashval  :=  HASH64(word);
  UNSIGNED2  freq     :=  COUNT(GROUP);
 END;
 TL  :=  TABLE(DL,  {HashWordRec(Word)},  Word);
 TR  :=  TABLE(DR,  {HashWordRec(Word)},  Word);

 dot :=  JOIN(TL,  TR,
              LEFT.hashval  =  RIGHT.hashval,
              TRANSFORM({UNSIGNED4  product},
              SELF.product  := LEFT.freq*RIGHT.freq));
 dot_product  :=  SUM(dot,  product);

 Lsqs  :=  SUM(TL,  POWER(freq,2));
 Rsqs  :=  SUM(TR,  POWER(freq,2));
 magnitudes_product  :=  SQRT(Lsqs)  *  SQRT(Rsqs);

 RETURN  ROUND(dot_product/magnitudes_product,15);
 END;
 

 