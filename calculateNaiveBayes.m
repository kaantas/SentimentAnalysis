function [ resultTable,accuracy,fscore,confusionMatrix ] = calculateNaiveBayes(posProbMap, negProbMap)
%Naive Bayes Classifier
%P(word | positive) = (word kelimesi positive yorumlarda toplam kaç kere geçmiþ + 1)/
%(Pozitifte toplam kaç kelime var + Train edilen yani calculate IG'den dönen tabloda her biri farklý toplam kaç tane kelime var (500))  
%testing.txt 1-219 arasý pozitif yorum var, 220den 438e kadar negatif yorum
resultTable=cell(1);
file = fopen('testing.txt');
line = fgetl(file);
line_count=1;
accuracy_count=0;
%tp (true positive) = gerçekte pozitif ve pozitif tahmin edilmiþ
tp=0;
%tn (true negative) = gerçekte negatif ve negatif tahmin edilmiþ
tn=0;
%fp (false positive) = gerçekte negatif ama pozitif tahmin edilmiþ
fp=0;
%fn (false negative) = gerçekte pozitif ama negatif tahmin edilmiþ
fn=0;
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

            %eðer test datasýndan aldýðýmýz bir yorum içinde geçen herhangi bir kelime bir feature'a eþitse
            %o kelimenin pozitif ve negatif file'lar için olasýlýklarýný
            %alýyoruz
            if posProbMap.isKey(word) || negProbMap.isKey(word)
                tmpPos(word)=posProbMap(word);
                tmpNeg(word)=negProbMap(word);
            %eðer bu kelimenin bir feature karþýlýðý yok ise hem pozitif
            %hem negatif olasýlýðýný 1 alýyoruz çünkü 0 alýrsak birazdan
            %uygulayacaðýmýz çarpma iþleminde sonuçlar 0 gelmesin
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
        
        %eðer test dosyasýndan aldýðýmýz bir yorum gerçekte pozitif ise ve
        %þimdi Naive Bayes kullanarak ulaþtýðýmýz sonuç da pozitif ise accuracy arttýr
        %o yorumun tahmin edilen classýný 1(pozitif) yaz
        if posResult > negResult
            accuracy_count=accuracy_count+1;
            tp=tp+1;
            %tahmin edilen class pozitif ise 1, negatif ise 0
            resultTable{line_count,1}=1;
        else
            fn=fn+1;
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
            tn=tn+1;
            resultTable{line_count,1}=0;
        else
            fp=fp+1;
            resultTable{line_count,1}=1;
        end
     end
     
     line=fgetl(file);
     line_count=line_count+1;
end
fclose(file);
accuracy = double((accuracy_count*100)/line_count);
precision = double(tp/(tp+fp));
recall = double(tp/(tp+fn));
fscore = double((2*(precision*recall))/(precision+recall));
confusionMatrix=cell(1);
confusionMatrix{2,1}='Actual Positive';
confusionMatrix{3,1}='Actual Negative';
confusionMatrix{1,2}='Predicted Positive';
confusionMatrix{1,3}='Predicted Negative';
confusionMatrix{2,2}=tp;
confusionMatrix{2,3}=fn;
confusionMatrix{3,2}=fp;
confusionMatrix{3,3}=tn;
end

