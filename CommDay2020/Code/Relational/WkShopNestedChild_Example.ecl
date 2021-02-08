ParentRec := RECORD
    INTEGER1  NameID;
    STRING20  Name;
END;
ChildRec := RECORD
    INTEGER1  NameID := 0;
    STRING20  Addr   := '';
END;
DenormedRec := RECORD
  ParentRec;                                
  UNSIGNED1 NumRows;                        
  DATASET(ChildRec) Children {MAXCOUNT(5)}; 
END;
NamesTable := DATASET([ {1,'Hugo'},
                        {2,'Eliana'},
                        {3,'Mr Nobody'},
                        {4,'Mr Anywhere'}], 
                      ParentRec);            
NormAddrs := DATASET([{1,'10 Malt Lane'},	
			                  {2,'10 Malt Lane'},	
			                  {2,'3 The cottages'},	
			                  {4,'Here'},	
			                  {4,'There'},	
			                  {4,'Near'},	
			                  {4,'Far'}],
										         ChildRec);	
DenormedRec ParentLoad(ParentRec Le) := TRANSFORM
  SELF.NumRows  := 0;
  SELF.Children := [];
  SELF          := Le;
END;
Ptbl := PROJECT(NamesTable,ParentLoad(LEFT));
OUTPUT(Ptbl,NAMED('ParentDataReady'));
Ptbl DeNormThem(Ptbl Le, NormAddrs Ri, INTEGER Ct) := TRANSFORM
  SELF.NumRows  := Ct;
  SELF.Children := Le.Children + Ri;
  SELF          := Le;
END;
DeNormedRecs := DENORMALIZE(Ptbl, NormAddrs,
				                    LEFT.NameID = RIGHT.NameID,
				                    DeNormThem(LEFT,RIGHT,COUNTER));
OUTPUT(DeNormedRecs,NAMED('NestedChildDataset'));
 
// *******************************
ParentRec ParentOut(DenormedRec Le) := TRANSFORM
    SELF := Le;
END;
Pout := PROJECT(DeNormedRecs,ParentOut(LEFT));
OUTPUT(Pout,NAMED('ParentExtracted'));
/* Using Form 1 of NORMALIZE */
ChildRec NewChildren(DenormedRecs Le, INTEGER C) := TRANSFORM
  SELF := Le.Children[C];
END;
                                             
NewChilds := NORMALIZE(DeNormedRecs,LEFT.NumRows,NewChildren(LEFT,COUNTER));
   
// Form 2 of NORMALIZE
ChildRec NewChildren2(ChildRec Ri) := TRANSFORM
 SELF := Ri;
END;
                                                                                                                     
NewChilds2 := NORMALIZE(DeNormedRecs,LEFT.Children,NewChildren2(RIGHT));
/* Using Modified Form 2 of NORMALIZE with inline TRANSFORM */
NewChilds3 := NORMALIZE(DeNormedRecs,LEFT.Children,TRANSFORM(RIGHT));  
      
OUTPUT(NewChilds,NAMED('Child1'));
OUTPUT(NewChilds2,NAMED('Child2'));
OUTPUT(NewChilds3,NAMED('Child3'));
// OR !!!!!!!!!!!!!!!
OUTPUT(PROJECT(DeNormedRecs.Children,Childrec),NAMED('NormProject'));
