function [ posProbMap,negProbMap ] = calculateProbabilities(IGTable, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count)
termCountInPos_map=resultTermCountInPos;
termCountInNeg_map=resultTermCountInNeg;
featuresTable=IGTable;
%featurlarýn hem pozitif file hem de negatif filedaki Probabilityleri
%hesaplanýyor
%bir feature'ýn pozitif file'daki Probabilitysi = posProbMap'te tutuluyor
posProbMap = containers.Map('KeyType','char','ValueType','double');  
%bir feature'ýn negatif file'daki Probabilitysi = negProbMap'te tutuluyor
negProbMap = containers.Map('KeyType','char','ValueType','double');
for i=1:500
    feature=char(featuresTable(i,1));    
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
    posProbMap(char(feature))=positiveProb;
    negProbMap(char(feature))=negativeProb;
end

end

