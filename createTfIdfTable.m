function [  ] = createTfIdfTable(  )
    positiveFile = fopen('positive.txt','r+');
    
    %her kelimenin df deðerlerinin tutulduðu map
    dfTable = containers.Map('KeyType','char','ValueType','int32');
    %her kelimenin tf deðerlerinin tutulduðu map
    tfTable = containers.Map('KeyType','char','ValueType','int32');
    
    %her line = bir yorum
    line = fgetl(positiveFile);
    %line_count = yorum (döküman) sayýsý
    line_count=1;
    while ischar(line)
          %harf olmayan karakterleri alma 
          line = regexprep(line,'[^A-Za-z_ðüþýöçÐÜÞÝÖÇ]',' ');
          %tüm kelimeleri küçük harf'e çevir
          line=lower(line);
          %boþluklara göre kelimeleri ayýr (tokenization) 
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
                
                %Stemming
                %fixed-prefix => n=5
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
                else
                    val = tmp(word);
                    tmp(word) = val + 1; 
                end    
          end
    
    end
    
    fclose(positiveFile);
end

