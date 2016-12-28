function [resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count] = tfIdfTermCount( )
    training = fopen('training.txt','r');
    dfMap = containers.Map('KeyType','char','ValueType','int32');  
    tf_map = containers.Map('KeyType','char','ValueType','any');
    %IG hesaplerken kullanýlacak pozitif file için df
    df_positive = containers.Map('KeyType','char','ValueType','int32');
    %IG hesaplerken kullanýlacak negatif file için df
    df_negative = containers.Map('KeyType','char','ValueType','int32');
    %Probability hesaplerken kullanýlacak positive file içindeki bir
    %kelimenin toplam kaç kere geçtiði
    termCountInPos_map = containers.Map('KeyType','char','ValueType','int32');
    termCountInNeg_map = containers.Map('KeyType','char','ValueType','int32');
    pos_word_count=0;
    neg_word_count=0;
    comment = fgetl(training);
    commentCount=1;  
    %createTrainingSet fonksiyonu çaðrýldýktan sonra oluþturulan training
    %file içindeki her yorum tek tek iþleniyor.
    while ischar(comment)
          %nümerik karakterleri kaldýr
          %her bir kelime arasý  noktalama iþaretlerini kaldýr
          %boþluk koy
          comment = regexprep(comment,'[^A-Za-z_ðüþýöçÐÜÞÝÖÇ]',' ');
          %tüm kelimeler küçük harfe dönüþüyor
          comment=lower(comment);
          %Tokenization = boþluklara göre comment içindeki her bir kelimeyi
          %ayýrdýk ve tekrar comment deðiþkenine atadýk
          comment = strsplit(comment);
 
          %comment içindeki her bir kelime kontrol edilip commentWords
          %mapine insert ediliyor
          commentWords = containers.Map('KeyType','char','ValueType','int32');
          
          for i=1:length(comment)
               word = char(comment(1,i));
               %Stop Words ~ 3 harften kýsa kelimeler ele alýnmýyor.
               if(length(word)<3)
                   continue;
               end
               %Stemming = Fixed-Prefix n=5
               if(length(word)>5)
                   word = word(1:5);
               end    
         
               if(~commentWords.isKey(word))
                    commentWords(word) = 1;
                    
                    %comment içindeki her bir kelimenin df deðerleri
                    %hesaplanarak dfMap'ine key value þeklinde ekleniyor.
                    if dfMap.isKey(word)
                        val = dfMap(word);
                        dfMap(word) = val + 1;
                    else    
                        dfMap(word) = 1;
                    end
                    
                    %her bir kelimenin positive classýna göre df'ini
                    %hesaplýyoruz
                    %bu df deðeri df_positive'de tutuluyor.
                    %bu deðerler information gain hesaplarken yardýmcý
                    %olacak
                    if commentCount<512
                         pos_word_count=pos_word_count+1; %pozitif dökümanda geçen toplam kelime sayýsý
                        
                        if df_positive.isKey(word)   % o ara df i de aradan çýkaralým
                            val = df_positive(word);
                            df_positive(word) = val + 1;
                        else    
                            df_positive(word) = 1;
                        end
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %bir kelimenin pozitif fileda toplam kaç kere
                        %geçtiði
                        if ~termCountInPos_map.isKey(word)
                            termCountInPos_map(word)=1;
                        else
                            val = termCountInPos_map(word);
                            termCountInPos_map(word)=val+1;
                        end
                        
                    %her bir kelimenin negative classýna göre df'ini
                    %hesaplýyoruz
                    %bu df deðeri df_negative'de tutuluyor.
                    else
                        neg_word_count=neg_word_count+1; %negatif dökümanda geçen toplam kelime sayýsý
                        
                        if df_negative.isKey(word)   % o ara df i de aradan çýkaralým
                        val = df_negative(word);
                        df_negative(word) = val + 1;
                        else    
                        df_negative(word) = 1;
                        end
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %bir kelimenin negatif fileda toplam kaç kere
                        %geçtiði
                        if ~termCountInNeg_map.isKey(word)
                            termCountInNeg_map(word)=1;
                        else
                            val = termCountInNeg_map(word);
                            termCountInNeg_map(word)=val+1;
                        end
                    end
                    
                %commentWords içindeki wordlerin tf deðerleri hesaplanýyor.    
                else
                    val = commentWords(word);
                    commentWords(word) = val + 1; 
                end    
          end

          commentWordsKeys = commentWords.keys;
          for j = 1:commentWords.length
             tfTable = cell(1);
             word = char(commentWordsKeys(1,j));
             
             if(tf_map.isKey(word))
                 tfTable = tf_map(word);
                 tf = commentWords(word);
                 tfTable{1,commentCount} = tf;
                 tf_map(word) = tfTable;
             else
                 tf = commentWords(word);
                 tfTable{1,commentCount} = tf;
                 tf_map(word) = tfTable;
             end
             
          end   
          
        comment=fgetl(training);
        commentCount=commentCount+1;
    end
 
    %tfTable içinde TF deðerleri bulunuyor.
    tfTable = cell(1);
    tfMapKeys = tf_map.keys();
    
    for i=1:length(tfMapKeys)    
         word  = char(tfMapKeys(1,i));
         tfTable{i,1} = word;
         
         %tempArray = wordun tf deðerlerini tutuyor
         tempArray = tf_map(char(word));     
         
         for j = 1 : length(tempArray)
             if(~isempty(tempArray{1,j}))
                tf = tempArray{1,j};                
                df = dfMap(word);
                tfIdf = double(double(tf) * log(double(commentCount/df))); 
                tfTable{i,j+1} = tfIdf;              
             else
                %tfIdf deðeri yoksa 0
                tfTable{i,j+1} = 0;
             end
         end   
    end 
    
    fclose(training);
    resultTermCountInPos = termCountInPos_map;
    resultTermCountInNeg = termCountInNeg_map;
    resultTFIDF = tfTable;
    resultDFmap = dfMap;
    resultDFpositive = df_positive;
    resultDFnegative = df_negative;
end

