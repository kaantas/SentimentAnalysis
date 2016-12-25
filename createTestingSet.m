function [] = createTestingSet()
file_positive = fopen('positive.txt','r+');
testingSet = fopen('testing.txt','w');

line = fgetl(file_positive); %her line bir yorum
lineCount=0;
while ischar(line)
    if lineCount < 511
        lineCount=lineCount+1;
        line=fgetl(file_positive);
        continue;
    else
        if lineCount >= 511 && lineCount <= 730
            fprintf(testingSet,'%s',char(line));
            fprintf(testingSet,'\n');
            line=fgetl(file_positive);
        else
            break;
        end
        lineCount=lineCount+1;
    end
end
fclose(file_positive);
file_negative = fopen('negative.txt','r+');

line = fgetl(file_negative); %her line bir yorum
lineCount=0;
while ischar(line)
    if lineCount < 511
        lineCount=lineCount+1;
        line=fgetl(file_negative);
        continue;
    else
        if lineCount >= 511 && lineCount <= 730
            fprintf(testingSet,'%s',char(line));
            fprintf(testingSet,'\n');
            line=fgetl(file_negative);
        else
            break;
        end
        lineCount=lineCount+1;
    end
end
fclose(file_negative);
fclose(testingSet);
end

