SetLtr := ['A','B','C','D'];
ds := DATASET(COUNT(SetLtr),TRANSFORM({UNSIGNED1 UID,STRING1 Ltr},
                                      SELF.UID := COUNTER,
                                      SELF.Ltr := SetLtr[COUNTER]),
                                      LOCAL);
Rec := {UTF8_40 txt};
StartXML := U8'<Dataset>\n'; 
EndXML   := U8'\n</Dataset>'; 
UTF8 BldXrow(UNSIGNED1 uid,STRING1 Ltr) := (UTF8)('<Row>' +
                                                  '<uid>' + uid + '</uid>' +
                                                  '<ltr>' + ltr + '</ltr>' +
                                                  '</Row>');
Xtxt := PROJECT(ds,TRANSFORM(Rec,
                             SELF.txt := CASE(COUNTER,1 => StartXML +
                                                           BldXrow(LEFT.UID,LEFT.Ltr),
                                               COUNT(ds) =>BldXrow(LEFT.UID,LEFT.Ltr) + EndXML,
                                                           BldXrow(LEFT.UID,LEFT.Ltr))));
StartJSON := U8'{"Row": [\n'; 
EndJSON   := U8'\n]}';
UTF8 BldJrow(UNSIGNED1 uid, STRING1 Ltr) := (UTF8)('{"uid": ' + uid + ', ' +
                                                   '"ltr": "' + ltr + '"}');
Jtxt := PROJECT(ds,TRANSFORM(Rec, 
                             SELF.txt := CASE(COUNTER, 1 => StartJSON + BldJrow(LEFT.UID,LEFT.Ltr) + ',',
                                               COUNT(ds) => BldJrow(LEFT.UID,LEFT.Ltr) + EndJSON,
                                                            BldJrow(LEFT.UID,LEFT.Ltr) + ',')));
OUTPUT(Xtxt,,'~DG::CreatedXMLoutput', CSV(UNICODE),OVERWRITE);
OUTPUT(Jtxt,,'~DG::CreatedJSONoutput', CSV(UNICODE),OVERWRITE);
