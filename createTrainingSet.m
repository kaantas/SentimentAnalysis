function [] = createTrainingSet ()
file_positive = fopen('positive.txt','r+');
file_negative = fopen('negative.txt','r+');
trainingSet = fopen('training.txt','w');

line = fgetl(file_positive); %her line bir yorum
lineCount=0;
while ischar(line)
    if lineCount < 510
        fprintf(trainingSet,'%s',char(line));
        fprintf(trainingSet,'\n');
        line=fgetl(file_positive);
    elseif lineCount < 1022
        fprintf(trainingSet,'%s',char(line));
        fprintf(trainingSet,'\n');
        line=fgetl(file_negative);
    else
        break;
    end
    lineCount=lineCount+1;
end
fclose(file_positive);
fclose(file_negative);
fclose(trainingSet);
end