IMPORT $.^.Util;

filelayout := RECORD
 REAL f1;
 REAL f2;
 REAL f3;
 REAL f4;
END;

TestDS := DATASET([{11.1, 12.2, 13.3, 99.4},
                   {21.5, 22.6, 23.7, 24.8},
                   {31.9, 32.0, 33.1, 34.2},
                   {41.3, 42.4, 43.5, 44.6}],
                   filelayout);

Util.MAC_CorrelationMatrix(TestDS,'~CommDay2022::CorrelationMatrix');


