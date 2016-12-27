function [ probabilityTable ] = calculateProbabilities( )
[ IGTable,weightedTable,resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, termCountInPos_map, termCountInNeg_map, pos_word_count, neg_word_count ] = calculateIG();
featuresTable=IGTable;
for i=1:500
    feature=char(featuresTable(i,1));    
    probabilityTable{i,1}=feature;
    if ~termCountInPos_map.isKey(feature)
        freqInPos = 0;
    else
        freqInPos = double(termCountInPos_map(feature));
    end
    
    if ~termCountInNeg_map.isKey(feature)
         freqInNeg = 0;
    else
         freqInNeg = double(termCountInNeg_map(feature));
    end
    
    positiveProb = double(double((freqInPos+1)/(pos_word_count+500)));
    negativeProb= double(double((freqInNeg+1)/(neg_word_count+500)));
    probabilityTable{i,2}=positiveProb;
    probabilityTable{i,3}=negativeProb;
end

end

