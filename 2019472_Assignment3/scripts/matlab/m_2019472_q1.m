function [] = m_2019472_q1(imName)

close all

path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';
numSuperpixels = 500;

Image = imread(strcat(path, 'inputs\', imName));
[L, numLabels] = superpixels(Image, numSuperpixels);
idx = label2idx(L);

numRows = size(Image,1);
numCols = size(Image,2);
outputImage = zeros([numRows numCols]);
meanColor = zeros([numLabels 3]);
meanCoords = zeros([numLabels 2]);
salValue = zeros([1 numLabels]);



for labelVal = 1:numLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    
    meanColor(labelVal, :) = [mean(Image(redIdx)) mean(Image(greenIdx)) mean(Image(blueIdx))];   
    
    [row, col] = ind2sub(size(Image), idx{labelVal});
    meanCoords(labelVal, :) = [mean(row), mean(col)];
end    

for i = 1:numLabels
    for j = 1:numLabels
        salValue(i) = salValue(i) + norm(meanColor(i, :) - meanColor(j, :))*(exp(-1*(norm(meanCoords(i, :) - meanCoords(j, :))/(numRows^2 + numCols^2)^0.5)));  
    end
end

for labelVal = 1:numLabels
    labelIds = idx{labelVal};
    outputImage(labelIds) = salValue(labelVal);
end 

outputImage = mat2gray(outputImage);
imwrite(outputImage, strcat(path, 'outputs\', '2019472_Q1.jpg'), 'Quality', 100)

figure
imshow(outputImage)
end

