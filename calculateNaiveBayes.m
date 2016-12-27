function [ resultTable,accuracy ] = calculateNaiveBayes( )
%Naive Bayes Classifier
%P(word | positive) = (word kelimesi positive yorumlarda toplam kaç kere geçmiþ + 1)/
%(Pozitifte toplam kaç kelime var + Train edilen yani calculate IG'den dönen tabloda her biri farklý toplam kaç tane kelime var (500))  
%testing.txt 1-219 arasý pozitif yorum var, 220den 438e kadar negatif yorum
resultTable=cell(1);
[posProbMap,negProbMap] = calculateProbabilities();
file = fopen('testing.txt');
line = fgetl(file);
line_count=1;
accuracy_count=0;
while ischar(line)
     %harf olmayan karakterleri at 
     %hepsini küçük harf haline getir
     %boþluklara göre ayýr.
     line = regexprep(line,'[^A-Za-z_ðüþýöçÐÜÞÝÖÇ]',' ');
     line=lower(line);
     line = strsplit(line);
     
     tmpPos = containers.Map('KeyType','char','ValueType','double');
     tmpNeg = containers.Map('KeyType','char','ValueType','double');
     
     for j=1:length(line)
            word = char(line(1,j));
            %3 harften kýsa kelimeleri dikkate alma
            if(length(word)<3)
                continue;
            end
            %kelimeleri ilk 5 harfine göre stemming et
            if(length(word)>5)
                word = word(1:5);
            end

            if posProbMap.isKey(word) || negProbMap.isKey(word)
                tmpPos(word)=posProbMap(word);
                tmpNeg(word)=negProbMap(word);
            else
                tmpPos(word)=1; %çarpma iþlemi sonucu 0 olmasýn diye 1 veriyoruz
                tmpNeg(word)=1;
            end
     end
     
     if line_count<220 %pozitif commentler için
        posKeys = tmpPos.keys;
        posResult = 1;
        negResult = 1;
        for a=1:length(tmpPos)
            posResult = posResult * tmpPos(char(posKeys(1,a)));
        end
        negKeys = tmpNeg.keys;
        for a=1:length(tmpNeg)
            negResult = negResult * tmpNeg(char(negKeys(1,a))); 
        end
        
        if posResult > negResult
            accuracy_count=accuracy_count+1;
            resultTable{line_count,1}=1; %pozitif ise 1 negatif ise 0
        else
            resultTable{line_count,1}=0;
        end
     else %negatif commentler için
        posKeys = tmpPos.keys; 
        posResult = 1;
        negResult = 1;
        for a=1:length(tmpPos)
            posResult = posResult * tmpPos(char(posKeys(1,a)));
        end
        negKeys = tmpNeg.keys;
        for a=1:length(tmpNeg)
            negResult = negResult * tmpNeg(char(negKeys(1,a))); 
        end
        
        if negResult > posResult
            accuracy_count=accuracy_count+1;
            resultTable{line_count,1}=0;
        else
            resultTable{line_count,1}=1;
        end
     end
     
     line=fgetl(file);
     line_count=line_count+1;
end
fclose(file);
accuracy = double((accuracy_count*100)/line_count);
end

