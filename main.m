[tfidf,x]=indexer();
weightedTable = tfidf;

%her bir kelimenin tf-idf deðerleri toplamý weightedTable'in 732. sütununa
%yerleþtiriliyor.
for i=1:4054
   sum=0;
   for j=2:731
        if(isempty(cell2mat(weightedTable(i,j))))
           continue;
        end
        sum=sum+cell2mat(weightedTable(i,j));
   end
  
   weightedTable(i,732)=num2cell(sum);
end

%kelimeleri tf-idf deðerleri toplamý en büyükten en küçüðe sýrala
weightedTable = sortrows(weightedTable,-732);

%ilk 2000'i al
weightedTable = weightedTable(1:2000,:);
