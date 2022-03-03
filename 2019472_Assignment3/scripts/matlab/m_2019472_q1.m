function [] = m_2019472_q1(imName)

close all

path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\inputs\';
Image = imread(strcat(path, imName));
imshow(Image)
numSuperpixels = 400;
[L, numLabels] = superpixels(Image, numSuperpixels);
% % change starting
% r(:,:,1) = [
% 
%      [1     2     3     4]
%      [5     6     7     8]
%      [9    10    11    12]
%     [13    14    15    16]];
% 
% 
% r(:,:,2) =[
%      [0     3     8    15]
%     [24    35    48    63]
%     [80    99   120   143]
%    [168   195   224   255]];
% 
% 
% r(:,:,3) = [
% 
%      [3     5     7     9]
%     [11    13    15    17]
%     [19    21    23    25]
%     [27    29    31    33]];
% Image = r;
% numLabels = 4;
% L = [[1     1     2     2]
%      [1     1     2     2]
%      [3     3     4     4]
%      [3     3     4     4]];
% change ends


idx = label2idx(L);
numRows = size(Image,1);
numCols = size(Image,2);
outputImage = zeros([numRows numCols]);

for labelVal = 1:numLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    meanColor(labelVal, :) = [mean(Image(redIdx)) mean(Image(greenIdx)) mean(Image(blueIdx))];   
    [row, col] = ind2sub(size(Image), idx{labelVal});
    meanCoords(labelVal, :) = [mean(row), mean(col)];
end    
whos meanColor
salValue = zeros([1 numLabels]);
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
figure
imshow(outputImage)
end

