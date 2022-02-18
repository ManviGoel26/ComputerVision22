function[] = m_2019472_q2(k)
close;


% Making the features dataset using the image dataset.
% Loading the images. Specify the variable values. 
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment2\';
imagefiles_path = strcat(path, 'inputs\dd\');
sizes = [16 4 1];

% Custom LBPF Function implementation. Returns feature vector of length
% (binSize * CellSize)
function feature = extractCustomLBPFeatures(Im, binSize, CellSize)
    [nRow, nCol] = size(Im);
    I2 = padarray(Im, [2 2]);

    localBinaryPatternImage = zeros([nRow nCol], 'uint8');
    for row = 3 : nRow
        for col = 3 : nCol
            centerPixel = I2(row, col);
            
            pixel7 = I2(row-1, col-1);
            if (max(pixel7, centerPixel) == 0)
                pixel7 = 0;
            else
                pixel7 = round(min(pixel7, centerPixel)/max(pixel7, centerPixel));
            end
		        
            pixel6 = I2(row-1, col);
            if (max(pixel6, centerPixel) == 0)
                pixel6 = 0;
            else
                pixel6 = round(min(pixel6, centerPixel)/max(pixel6, centerPixel));
            end
		    
            pixel5 = I2(row-1, col+1);
            if (max(pixel5, centerPixel) == 0)
                pixel5 = 0;
            else
                pixel5 = round(min(pixel5, centerPixel)/max(pixel5, centerPixel));
            end
		    
            pixel4 = I2(row, col+1);
            if (max(pixel4, centerPixel) == 0)
                pixel4 = 0;
            else
                pixel4 = round(min(pixel4, centerPixel)/max(pixel4, centerPixel));
            end
		    
            pixel3 = I2(row+1, col+1);
            if (max(pixel3, centerPixel) == 0)
                pixel3 = 0;
            else
                pixel3 = round(min(pixel3, centerPixel)/max(pixel3, centerPixel));
            end
		    
            pixel2 = I2(row+1, col);
            if (max(pixel2, centerPixel) == 0)
                pixel2 = 0;
            else
                pixel2 = round(min(pixel2, centerPixel)/max(pixel2, centerPixel));
            end
		    
            pixel1 = I2(row+1, col-1);
            if (max(pixel1, centerPixel) == 0)
                pixel1 = 0;
            else
                pixel1 = round(min(pixel1, centerPixel)/max(pixel1, centerPixel));
            end
		    
            pixel0 = I2(row, col-1);
            if (max(pixel0, centerPixel) == 0)
                pixel0 = 0;
            else
                pixel0 = round(min(pixel0, centerPixel)/max(pixel0, centerPixel));
            end
                
            eightBitNumber = uint8(...
                pixel5 * 2^7 + pixel4 * 2^6 + ...
			    pixel3 * 2^5 + pixel2 * 2^4 + ...
			    pixel1 * 2^3 + pixel0 * 2^2 + ...
			    pixel7 * 2 + pixel6);

            localBinaryPatternImage(row, col) = eightBitNumber;
        end
    end
   
    feature = [];
    wholeBlockRows = nRow / CellSize(1);
    blockVectorR = [CellSize(1)*ones(1, wholeBlockRows)];
    wholeBlockCols = nCol / CellSize(2);
    blockVectorC = [CellSize(2)* ones(1, wholeBlockCols)];

%     Divide the image into multiple patches
    ca = mat2cell(localBinaryPatternImage, blockVectorR, blockVectorC);
    numPlotsR = size(ca, 1);
    numPlotsC = size(ca, 2);
    for r = 1 : numPlotsR
      for c = 1 : numPlotsC
        feature = cat(1, imhist(ca{r,c}, binSize), feature);
      end
    end
end


imDir = dir([imagefiles_path '*.jpg']);
noFiles = numel(imDir);

for im = 1 : noFiles
    I = imread(strcat(imagefiles_path, imDir(im).name));
    I = imresize(I, [256 256]);
    I = rgb2gray(I);
    
    lbpFeature = [];
    len = size(sizes);

    for s = 1 : len(2)
        numPatches = sizes(s);
        feature = extractCustomLBPFeatures(I, 10, [256/numPatches^0.5 256/numPatches^0.5]);
%         feature = extractLBPFeatures(I, 'Upright', false, 'CellSize', [256/numPatches^0.5 256/numPatches^0.5]);
       lbpFeature = cat(1, lbpFeature, feature);
    end

%     Make the dataset
   X(im, :) = lbpFeature';
end

% Fuzzy C Means Clustering
[~, u] = fcm(X, k);
maxU = max(u);

% Making the subfolders and thresholding for the fcm
for i = 1:k
    indexes = find(u(i, :) == maxU);
    lenI = size(indexes);
    parentFolder = strcat(path, 'Outputs\2019472_Q2');
    dirName = strcat('Cluster', int2str(i));
    mkdir(parentFolder, dirName)
    for ind = 1:lenI(2)
        I = imread(strcat(imagefiles_path, imDir(indexes(ind)).name));
        imwrite(I, strcat(path, "Outputs\2019472_Q2\Cluster", int2str(i), '\', int2str(ind), ".jpg"));
    end
end

end