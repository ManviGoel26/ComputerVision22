function [] = m_2019472_q1(imName)

close all

path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';

% The number of superpixels
numPixels = [10, 20, 50, 100, 200, 500, 1000, 1500, 2000, 10000];

Image = imread(strcat(path, 'inputs\', imName));
fid = fopen(strcat(path, 'Outputs\2019472_Q1.csv'), 'w' );


for numSuperpix = 1:size(numPixels, 2)
    numSuperpixels = numPixels(numSuperpix);
    % Calculate the superpixels
    [L, numLabels] = superpixels(Image, numSuperpixels, 'Compactness', 13);
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
        for k = 1:numLabels
            salValue(i) = salValue(i) + norm(meanColor(i, :) - meanColor(k, :))*(exp(-1*(norm(meanCoords(i, :) - meanCoords(k, :))/(nRows^2 + nCols^2)^0.5)));  
        end
    end
    
    % Make the saliency map
    for label = 1:numLabels
        labelIds = ids{label};
        salMap(labelIds) = salValue(label);
    end 
    
    % Normalize the saliency map and save the output
    salMap = mat2gray(salMap);
    imwrite(salMap, strcat(path, 'outputs\2019472_Q1\', num2str(numSuperpixels), '.jpg'), 'Quality', 100)

    [m1, mask] = sepMeasure(salMap);
    
    disp("The separation measure")
    disp(m1);

    % Second Quality Measure
    m2 = conMeasure(mask);
    
    
    disp("The concentration measure")
    disp(m2);

    outputs = [m1 m2];
    fprintf(fid, '%s, %f, %f\n', num2str(numSuperpixels), outputs(1), outputs(2));
    
    % Display the image
    figure
    imshow(salMap)
end
fclose(fid);



function [m1, mask1] = sepMeasure(sm)
%     sm = double(sm)/255;
    mask1 = imbinarize(sm, graythresh(sm));
    
    fg = sm(mask1);
    bg = sm(~mask1);
    
    if isempty(fg)
        fg = 0;
    end

    if isempty(bg)
        bg = 0;
    end
    
    
    meanFG = sum(fg(:))/(sum(mask1(:)) + eps);
    meanBG = sum(bg(:))/(sum(~mask1(:)) + eps);
    stdFG = sqrt(var(fg(:))) + eps;
    stdBG = sqrt(var(bg(:))) + eps;
    
    x = linspace(0, 1, 1000);
    dists = [exp(-0.5*((x-meanFG)/stdFG).^2)/(stdFG*sqrt(2*pi));exp(-0.5*((x-meanBG)/stdBG).^2)/(stdBG*sqrt(2*pi))];
   
    a = 1/stdBG^2-1/stdFG^2;
    b = -2*(meanBG/stdBG^2-meanFG/stdFG^2);
    c = meanBG^2/stdBG^2-meanFG^2/stdFG^2+2*(log(stdBG+eps)-log(stdFG+eps));

    rt = roots([a b c]);
    rt = rt(rt >= 0);
    rtx = rt(rt <= 1);
    rtx = rtx(1);
    fg1 = dists(1,:);
    fg2 = dists(2,:);
    m1 = 1/(1+1000*log10(1+sum(fg1(x<rtx))+sum(fg2(x>=rtx))));

end

function m2 = conMeasure(mask)
    maskD = double(mask);
    CC = bwconncomp(maskD);
    OS = CC.NumObjects;
    numPixel = cellfun(@numel,CC.PixelIdxList);

    sumCC = 0;

    for j = 1:OS
        sumCC = sumCC + numPixel(j);
    end
    CPrimeS = max(numPixel)/sumCC;
    m2 = CPrimeS + (1-CPrimeS)/(OS);
end







end

