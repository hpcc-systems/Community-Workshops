IMPORT Std, $;
MultiRec := RECORD
 UNSIGNED1 id1;
 UNSIGNED1 id2;      //id2 within id1
 STRING25 Lname;
 STRING15 Fname;
END;
Base2 := DATASET([
{1,1, 'LONDON','BILLY'},
{1,2, 'SMITH' ,'FRANK'},
{1,3, 'SMITH' ,'SUE'},
{2,1, 'SMITH' ,'NANCY'},
{2,2, 'SMITH' ,'FRED'},
{3,1, 'TAYLOR','FRANK'},
{3,2, 'JONES' ,'FRANK'},
{3,3, 'TAYLOR','RICHARD'}], MultiRec); 

Update2 := DATASET([
{1,1, 'LONDON','William'},
{3,1, 'TAYLOR','Franklin'},
{2,3, 'JONES' ,'FRED'},
{3,4, 'JONES' ,'GEORGE'}], MultiRec);

NewFile := $.IncrementalAddChgMulti(Base2, Update2,'id1,id2','Lname,Fname');
Newfile2 := '~DG::Base2_' + Std.Date.Today();
OUTPUT(SORT(NewFile,id1,id2),,Newfile2,OVERWRITE);
