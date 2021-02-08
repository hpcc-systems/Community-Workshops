IMPORT $.^ AS Root;
Base     := Root.File_PeopleAll;
NormProp := Root.File_Property.File;
NormPeep := Root.File_People.File;
EXPORT IDX := MODULE
//Standard (non-payload):
EXPORT StdIDX  := INDEX(Base.PeoplePlus,{lastname,firstname,recpos},'~WKSHP::BMF::StdNameIndex');
//Payload for simple search:
EXPORT BaseIDX := INDEX(Base.People,{lastname,firstname},{Base.People},'~WKSHP::BMF::NameIndex');
//Payloads for half keyed join
EXPORT PropPayIDX  := INDEX(NormProp,{house_number,house_number_suffix,predir,street,
                                      streettype,postdir,apt,city,state,zip},
																			            {personid},'~WKSHP::BMF::PropPayIndex');
EXPORT PeoplePayID := INDEX(NormPeep,{id},{NormPeep},'~WKSHP::BMF::PeoplePayIDIndex');
END;
