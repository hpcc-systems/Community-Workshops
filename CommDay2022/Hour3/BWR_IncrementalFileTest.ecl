IMPORT $, Std;
PtblRec := RECORD
 INTEGER2  UID;
 STRING2  State;
 STRING20 City;
 STRING25 Lname;
 STRING15 Fname;
END; 

Orig := DATASET([
{3000,'FL','BOCA RATON','LONDON','BILLY'},
{35,'FL','BOCA RATON','SMITH','FRANK'},
{50,'FL','BOCA RATON','SMITH','SUE'},
{135,'FL','BOCA RATON','SMITH','NANCY'},
{235,'FL','BOCA RATON','SMITH','FRED'},
{335,'FL','BOCA RATON','TAYLOR','FRANK'},
{3500,'FL','BOCA RATON','JONES','FRANK'},
{30,'FL','BOCA RATON','TAYLOR','RICHARD'}], PtblRec);


UpdRecs := DATASET([
//2 new recs:
{40,'FL','BOCA RATON','SMITH','SUE'},
{45,'FL','BOCA RATON','SMITH','JOHN'},
//1 deletion:
{-35,'FL','BOCA RATON','SMITH','FRANK'},
//2 changed recs:
{50,'FL','BOCA RATON','SMITH','SUSAN'},
{235,'FL','BOCA RATON','SMITH','FREDERICK'}], PtblRec);


NewBaseFile := $.IncrementalAddChgRecs(Orig,UpdRecs, UID,'State,City,Lname,Fname');
NewfileName1 := '~DG::Base1_' + Std.Date.Today();
OUTPUT(NewBaseFile,,NewfileName1,OVERWRITE); 
