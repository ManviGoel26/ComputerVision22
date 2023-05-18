function [] = m_2019472_q2(imName)

close all;
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';

Image = imread(strcat(path, 'inputs\', imName));
[r, c, ~] = size(Image);

% Turn to grayscale to get the coordinates
gImage = rgb2gray(Image);
[y, x] = find(gImage ~= 0); 
coor = [x, y];


featureImage = reshape(double(Image), [r*c, 3]);
featureImage = cat(2, featureImage, coor);
featureImage = normalize(featureImage);


epsilons = [0.01, 0.02, 0.05, 0.08, 0.1, 0.12, 0.15, 0.2, 0.25, 0.3, 0.5, 1, 2, 10];
minNumbers = [2, 5, 10, 15, 20, 25, 30, 40, 50, 80, 100];

for i = 1:size(epsilons, 2)
    for j = 1:size(minNumbers, 2)
        ids = dbscan(featureImage, epsilons(i), minNumbers(j));
        pixelLabels = reshape(ids, [r, c]);
        pixelLabels = mat2gray(pixelLabels);
        figure, imshow(pixelLabels)
        imwrite(pixelLabels, strcat(path, 'outputs\2019472_Q2\', num2str(epsilons(i)), '-', num2str(minNumbers(j)), '.jpg'), 'Quality', 100)
    end
end

% KNN search for estimating the value of epsilon.
% for i = 1:size(minNumbers, 2)
%     [~, distance] = knnsearch(featureImage, [featureImage], 'K', minNumbers(i));
%     sortD = sort(distance);
%     plot(sortD);
%     pause(10)
% end


end