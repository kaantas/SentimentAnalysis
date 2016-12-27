function [resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count] = indexer()
    trainingFile = fopen('training.txt','r');
    df_map = containers.Map('KeyType','char','ValueType','int32');  
    tf_map = containers.Map('KeyType','char','ValueType','any');
    df_positive = containers.Map('KeyType','char','ValueType','int32');
    df_negative = containers.Map('KeyType','char','ValueType','int32');
    termCountInPos_map = containers.Map('KeyType','char','ValueType','int32');
    termCountInNeg_map = containers.Map('KeyType','char','ValueType','int32');
    pos_word_count=0;
    neg_word_count=0;
    line = fgetl(trainingFile); %her line bir yorum
    line_count=1;  
    %positive.txt dosyasýndan kelimeler line olarak alýnýyor.
    while ischar(line)
          %harf olmayan karakterleri at 
          %hepsini küçük harf haline getir
          %boþluklara göre ayýr.
          line = regexprep(line,'[^A-Za-z_ðüþýöçÐÜÞÝÖÇ]',' ');
          line=lower(line);
          line = strsplit(line);
          
          %line içindeki kelimeler teker teker ele alýnýp uygun olanlar map
          %e ekleniyor.
          tmp = containers.Map('KeyType','char','ValueType','int32');
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
         
               %tf hesaplamak için tf say
                if(~tmp.isKey(word))
                    tmp(word) = 1;
                    if df_map.isKey(word)   % o ara df i de aradan çýkaralým
                        val = df_map(word);
                        df_map(word) = val + 1;
                    else    
                        df_map(word) = 1;
                    end
                    
                    %her bir kelimenin positive classýna göre df'ini
                    %hesaplýyoruz
                    %bu df deðeri df_positive'de tutuluyor.
                    %bu deðerler information gain hesaplarken yardýmcý
                    %olacak
                    if line_count<512
                         pos_word_count=pos_word_count+1; %pozitif dökümanda geçen toplam kelime sayýsý
                        
                        if df_positive.isKey(word)   % o ara df i de aradan çýkaralým
                            val = df_positive(word);
                            df_positive(word) = val + 1;
                        else    
                            df_positive(word) = 1;
                        end
                        
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
                        
                        if ~termCountInNeg_map.isKey(word)
                            termCountInNeg_map(word)=1;
                        else
                            val = termCountInNeg_map(word);
                            termCountInNeg_map(word)=val+1;
                        end
                    end
                else
                    val = tmp(word);
                    tmp(word) = val + 1; 
                end    
          end
          
          %bu line da geçen kelimeler keys in içinde tf deðerleri ile
          %bulunuyor
          keys = tmp.keys;
          %keys in içindeki herkelimenin tf ini 
          %ilgili kelime ve line
          %countuna göre indexlenmiþ tf deðerini yazarak tf_map'inde
          %güncelle
          for c = 1:tmp.length
             tf_cell = cell(1);
             word = char(keys(1,c));
             if(tf_map.isKey(word))
                 tf_cell = tf_map(word);
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             else
                 tf_val = tmp(word);
                 tf_cell{1,line_count} = tf_val;
                 tf_map(word) = tf_cell;
             end
          end   
          
        line=fgetl(trainingFile);
        line_count=line_count+1;
    end
 
    
    %tf lerin yazýlacaðý bir cell tablosu oluþturuluyor.
    tf_cell = cell(1);
    keys = tf_map.keys();                           %keyler tf_map ten çekildi
    for i=1:length(keys)    
        word  = char(keys(1,i));                    %her kelime ayrý ayrý alýnýyor.
        tf_cell{i,1} = word;                        %ve cellin 1. sütununa yazýlýyor
             tmp_cell = tf_map(char(word));         %ve ilgili kelimenin tf deðerlerini içeren cell arrayi alýnýyor
             for j = 1 : length(tmp_cell)
                 if(~isempty(tmp_cell{1,j}))
                 tf = tmp_cell{1,j};                %tf deðerleri tf mapinden alýnýyor.
                 df = df_map(word);                 %df deðerleri df mapinden alýnýyor.
                 idf = double(double(tf) * log(double(line_count/df))); %idf hesaplanýyor
                 tf_cell{i,j+1} = idf;              %ve diðer sütunlara idf deðerleri yazýlýyor.
                 else
                 tf_cell{i,j+1} = 0;                %eðer tf deðeri boþ dönmüþ ise 0 yazýlyor.
                 end
             end   
    end    
    fclose(trainingFile);
    resultTermCountInPos = termCountInPos_map;
    resultTermCountInNeg = termCountInNeg_map;
    resultTFIDF = tf_cell;
    resultDFmap = df_map;
    resultDFpositive = df_positive;
    resultDFnegative = df_negative;
end