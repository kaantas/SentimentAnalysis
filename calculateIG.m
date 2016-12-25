function [ IGTable, sortedIGTable ] = calculateIG( )
%P(positive)=1/2
%P(negative)=1/2
%P(word)=>from function
%~P(word)=1-P(word)
%P(positive|word)=word, kaç tane positive yorumda geçmiþ / word, toplam kaç tane yorumda geçmiþ (df) 
%P(positive|~word)=kaç tane positive yorumda bu word yok (Npositive-dfpositive) / N-df
%P(negative|word)
%P(negative|~word)
IGTable = cell(1);
weightedTable = preprocessedTable();
[resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative] = indexer();
Ppositive = 1/2;
Pnegative = 1/2;

for i=1:3000 %3000 toplam kelime sayýsý
    word = char(weightedTable(i,1));
    if ~resultDFpositive.isKey(word)
        resultDFpositiveWord = 0;
    else
        resultDFpositiveWord = double(resultDFpositive(word));
    end
    
    if ~resultDFnegative.isKey(word)
        resultDFnegativeWord = 0;
    else
        resultDFnegativeWord = double(resultDFnegative(word));
    end
    
    if resultDFmap(word) == 0
        resultDFword = 1;
    else
        resultDFword = double(resultDFmap(word));
    end
    
    Pword = double(resultDFmap(word))/1022;
    notPword = 1-Pword;
    positivePword = resultDFpositiveWord/resultDFword;
    notPositivePword = (511 - resultDFpositiveWord)/(1022-double(resultDFmap(word)));
    negativePword = resultDFnegativeWord/resultDFword;
    notNegativePword = (511 - resultDFnegativeWord)/(1022-double(resultDFmap(word)));
    
    if isnan(positivePword*log(positivePword))
        positiveMultiple = 0;
    else
        positiveMultiple = positivePword*log(positivePword);
    end
    
    if isnan(notPositivePword*log(notPositivePword))
        notPositiveMultiple = 0;
    else
        notPositiveMultiple = notPositivePword*log(notPositivePword);
    end
    
    if isnan(notNegativePword*log(notNegativePword))
        notNegativeMultiple = 0;
    else
        notNegativeMultiple = notNegativePword*log(notNegativePword);
    end
    
    if isnan(negativePword*log(negativePword))
        negativeMultiple = 0;
    else
        negativeMultiple = negativePword*log(negativePword);
    end
    a = -(Ppositive*log(Ppositive)+Pnegative*log(Pnegative));
    b = Pword *(positiveMultiple + negativeMultiple);
    c = notPword * (notPositiveMultiple + notNegativeMultiple);
    
    Gword = a+b+c;
    IGTable(i,1)=cellstr(word);
    IGTable(i,2)=num2cell(Gword);
end

%kelimeleri tf-idf deðerleri toplamý en büyükten en küçüðe sýrala
sortedIGTable = sortrows(IGTable,-2);

%ilk 500'i al
sortedIGTable = sortedIGTable(1:500,:);
end