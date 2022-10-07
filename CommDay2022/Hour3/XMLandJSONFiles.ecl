SetLtr := ['A','B','C','D'];
//Generating simple XML and JSON:
ds := DATASET(COUNT(SetLtr),TRANSFORM({UNSIGNED1 UID,STRING1 Ltr}, SELF.UID := COUNTER,
                                                                   SELF.Ltr := SetLtr[COUNTER]));
 OUTPUT(ds,,'~DG::StandardXMLoutput',XML,OVERWRITE);
 OUTPUT(ds,,'~DG::StandardJSONoutput',JSON,OVERWRITE);
/* Produces this XML file:
<Dataset>
<Row><uid>1</uid><ltr>A</ltr></Row>
<Row><uid>2</uid><ltr>B</ltr></Row>
<Row><uid>3</uid><ltr>C</ltr></Row>
<Row><uid>4</uid><ltr>D</ltr></Row>
</Dataset> 

and this JSON file:
{"Row": [
{"uid": 1, "ltr": "A"},
{"uid": 2, "ltr": "B"},
{"uid": 3, "ltr": "C"},
{"uid": 4, "ltr": "D"}
]} */

//Generating an XML attribute:
ds2 := DATASET(COUNT(SetLtr),TRANSFORM({UNSIGNED1 UID{XPATH('@uid')}, STRING1 Ltr},
                            SELF.UID := COUNTER,
                            SELF.Ltr := SetLtr[COUNTER]));
OUTPUT(ds2,,'~DG::StandardXMLoutput2',XML,OVERWRITE);

//Changing XML row and file Tags:
OUTPUT(ds2,,'~DG::StandardXMLoutput3', XML('row',HEADING('<XML>\n','</XML>')), OVERWRITE);
/* Produces this file:
<XML>
<row uid="1" ltr="A"/>
<row uid="2" ltr="B"/>
<row uid="3" ltr="C"/>
<row uid="4" ltr="D"/>
</XML>
*/

//Changing JSON row and file Tags
OUTPUT(ds,,'~DG::StandardJSONoutput2', JSON('rows',HEADING('[',']')),OVERWRITE);
/* Produces this JSON file:
[{"rows": [
{"uid": 1, "ltr": "A"},
{"uid": 2, "ltr": "B"},
{"uid": 3, "ltr": "C"},
{"uid": 4, "ltr": "D"}
]}] */

