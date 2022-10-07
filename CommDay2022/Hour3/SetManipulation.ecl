IMPORT $.^.Util;

Set_state :=
['CT','WY','DC','DE','WV','PR','WI',
'CA','WA','CO','PA','AZ','OR','IA',
'VI','ID','AR','AS','VA','UT','IN',
'AP','IL','AK','AL','OH','OK','HI',
'AA','VT','NC','AE','MT','MS','NE',
'ND','MP','TX','GA','NH','NJ','NM',
'MD','ME','NV','FL','MA','MO','NY',
'MN','GU','MI','TN','SD','KY','SC',
'LA','KS','RI'];
ds := DATASET(Set_State,{STRING2 st}); StateSet := SET(ds,st);

Util.Sets.SortSet(StateSet);
Util.Sets.SortSet(StateSet,'D');

Util.Sets.RankSet(29,StateSet);  //1
Util.Sets.RankSet(29,StateSet,'D'); //59

Util.Sets.RankedSet(1,StateSet); //29
Util.Sets.RankedSet(1,StateSet,'D'); //2

Util.Sets.ToStr(['Abc', 'Def', 'Ghi'],'');
Util.Sets.ToStr(['Abc', 'Bcd', 'Cde'],':');
Util.Sets.ToStr([42,33,56789,88,666],','); 
