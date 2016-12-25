function [ output_args ] = calculateIG(  )
%P(positive)=1/2
%P(negative)=1/2
%P(word)=>from function
%~P(word)=1-P(word)
%P(positive|word)=word, kaç tane positive yorumda geçmiþ / word, toplam kaç tane yorumda geçmiþ (df) 
%P(positive|~word)=kaç tane positive yorumda bu word yok / 1-df
%P(negative|word)
%P(negative|~word)
weightedTable = preprocessedTable();



end

function result = P(word)
[x,dfMap]=indexer();
df_map = dfMap;

df_value = df_map(word); %verilen kelimenin df deðeri
N = 730; %toplam dök sayýsý

result = df_value/N;
end