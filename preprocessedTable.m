function [ weightedTable ] = preprocessedTable(resultTFIDF)
weightedTable = resultTFIDF;

%her bir kelimenin tf-idf deðerleri toplamý weightedTable'in 1024. sütununa
%yerleþtiriliyor.
for i=1:4956
   sum=0;
   for j=2:1023
        if(isempty(cell2mat(weightedTable(i,j))))
           continue;
        end
        sum=sum+cell2mat(weightedTable(i,j));
   end
  
   weightedTable(i,1024)=num2cell(sum);
end

%kelimeleri tf-idf deðerleri toplamý en büyükten en küçüðe sýrala
weightedTable = sortrows(weightedTable,-1024);

%ilk 3000'i al
weightedTable = weightedTable(1:3000,:);
end

