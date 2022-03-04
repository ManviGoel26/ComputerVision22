function [] = m_2019472_q1(imName)

close all

path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';

% The number of superpixels
numSuperpixels = 500;

Image = imread(strcat(path, 'inputs\', imName));

% Calculate the superpixels
[L, numLabels] = superpixels(Image, numSuperpixels);
ids = label2idx(L);

% Initialize matrices for storing datas
nRows = size(Image,1);
nCols = size(Image,2);
salMap = zeros([nRows nCols]);
meanColor = zeros([numLabels 3]);
meanCoords = zeros([numLabels 2]);
salValue = zeros([1 numLabels]);


% Calculate the mean colors and coordinates
for label = 1:numLabels
    meanColor(label, :) = [mean(Image(ids{label})) mean(Image(ids{label} + nRows*nCols)) mean(Image(ids{label} + 2*nRows*nCols))];       
    
    [row, col] = ind2sub(size(Image), ids{label});
    meanCoords(label, :) = [mean(row), mean(col)];
end    


% Calculate the saliency value for each superpixel
for i = 1:numLabels
    for j = 1:numLabels
        salValue(i) = salValue(i) + norm(meanColor(i, :) - meanColor(j, :))*(exp(-1*(norm(meanCoords(i, :) - meanCoords(j, :))/(nRows^2 + nCols^2)^0.5)));  
    end
end

% Make the saliency map
for label = 1:numLabels
    labelIds = ids{label};
    salMap(labelIds) = salValue(label);
end 

% Normalize the saliency map and save the output
salMap = mat2gray(salMap);
imwrite(salMap, strcat(path, 'outputs\', '2019472_Q1.jpg'), 'Quality', 100)

% Display the image
figure
imshow(salMap)
end

