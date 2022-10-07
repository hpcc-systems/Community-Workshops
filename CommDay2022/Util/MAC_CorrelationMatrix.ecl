//MACRO that takes a dataset from which to generate the
//Correlation Matrix and the name of the output logical file
EXPORT MAC_CorrelationMatrix(inds,outname) := MACRO
 thislayout := {STRING field,RECORDOF(inds)};
 #EXPORTXML(Fred,RECORDOF(inds));
 #DECLARE(SetValStr);
 #DECLARE(SetFldStr);
 #DECLARE(PrjStr);
 #DECLARE(FldStr);
 #DECLARE(Ndx);
 #SET(Ndx, 0);
 #FOR(Fred)
  #FOR(Field)
   #SET(Ndx, %Ndx% + 1)
   #IF( %Ndx% = 1)
    #SET(SetValStr,'SetVals := [' +
         #TEXT(inds) + '.' +
         %'{@label}'% );
    #SET(SetFldStr,'SetFlds := [\'' +
         %'{@label}'% + '\'');
    #SET(PrjStr,'thislayout XF(INTEGER C) ' +
                ':= TRANSFORM\n' +
                ' SELF.field := SetFlds[C];\n'+
                ' SELF.' + %'{@label}'% +
                ' := CORRELATION(' +
                #TEXT(inds) +
                ',SetVals[C],' +
                %'{@label}'% + ');\n');
   #ELSE 
    #APPEND(SetValStr,',' + #TEXT(inds) + '.' + %'{@label}'%);
    #APPEND(SetFldStr,',\'' + %'{@label}'% + '\'');
    #APPEND(PrjStr,' SELF.' + %'{@label}'%  + ' := CORRELATION(' +
                   #TEXT(inds) + ',SetVals[C],' + %'{@label}'% + ');\n');
   #END
  #END
 #END
 #APPEND(SetValStr,'];\n');
 #APPEND(SetFldStr,'];\n');
 #APPEND(PrjStr,'END;\n' +
                'Matrix := DATASET(' +
                'COUNT(SetVals),XF(COUNTER));\n');
 %SetValStr%;
 %SetFldStr%;
 %PrjStr%;

 OUTPUT(%'SetValStr'%+%'SetFldStr'%+%'PrjStr'%);
 OUTPUT(Matrix,,outname, OVERWRITE);
ENDMACRO;
