function[] = m_2019472_q3(ImName, k)
close;

path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment2\';
imagefiles_path = strcat(path, 'inputs\dd\');
nrows = 128;
ncols = 64;
numPatch = 16;


function [features, featureMetrics] = customExtract(Image)
Image = imresize(Image, [nrows ncols]);
fV = extractHOGFeatures(Image, 'CellSize', [nrows/(numPatch^0.5) ncols/(numPatch^0.5)], 'BlockSize', [1 1], 'BlockOverlap', [0 0], 'NumBins', 9);
features = reshape(fV', [9 numPatch])';
featureMetrics = ones(numPatch, 1);
end

% imDir = dir([imagefiles_path '*.jpg']);
imds = imageDatastore(imagefiles_path);
extractor = @customExtract;
bag = bagOfFeatures(imds, 'CustomExtractor', extractor, 'StrongestFeatures', 1, 'TreeProperties', [1 k], 'Verbose', false);

% Making the feature vector for the given image
Im = imread(strcat(path, 'inputs\', ImName));
featureVnone = encode(bag, Im, 'Normalization', 'none');
featureVL2 = encode(bag, Im);

disp("The unnormalised feature vector")
disp(featureVnone)
disp(newline)
disp("The L2 normalised feature vector")
disp(featureVL2);


% whos imds;
end