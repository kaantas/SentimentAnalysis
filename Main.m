%positive.txt ve negative.txt dosyalarýnda %70'i training olacak
%þekilde training.txt dosyasý oluþturuluyor.
createTrainingSet();

%tfIdfTermCount fonksiyonu ile kelimelerin tf idf deðerleri ve sonraki
%fonksiyonlarda kullanýlacak deðerler hesaplanýyor.
[resultTFIDF, resultDFmap, resultDFpositive, resultDFnegative, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count] = tfIdfTermCount( );

%preprocessedTable foksiyonu ile kelimelerin tfidf deðerleri toplanarak bir
%sort iþlemi gerçekleþtiriliyor. En büyük deðere sahip 3000kelime alýnarak
%deðersiz kelimeler atýlýyor ve toplam kelime sayýsý azaltýlýyor.
weightedTable = preprocessedTable(resultTFIDF);

%calculateIG fonksiyonu ile kelimelerin information gain deðerleri
%hesaplanýyor ve en ayýrt edici 500 kelime feature olarak seçiliyor.
IGTable = calculateIG(weightedTable, resultDFmap, resultDFpositive, resultDFnegative);

%calculateProbabilities fonksiyonu ile feature'larin hem pozitif hem
%negatif classlar için olasýlýklarý hesaplanýyor.
[posProbMap, negProbMap] = calculateProbabilities(IGTable, resultTermCountInPos, resultTermCountInNeg, pos_word_count, neg_word_count);

%positive.txt ve negative.txt dosyalarýnda %30'u testing olacak
%þekilde testing.txt dosyasý oluþturuluyor.
createTestingSet();

%testing.txt dosyasýndan alýnan yorumlar ile Naive Bayes ile oluþturduðumuz
%classification methodu test ediliyor ve accuracy deðeri hesaplanýyor.
[resultTable, accuracy] = calculateNaiveBayes(posProbMap, negProbMap);
