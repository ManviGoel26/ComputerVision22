function[] = m_2019472_q4(ImName, k)

close;

% Making the features dataset using the image dataset.
% Loading the images. Specify the variable values. 
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment2\';
imagefiles_path = strcat(path, 'inputs\dd\');
numFeatures = 50;

imDir = dir([imagefiles_path '*.jpg']);
noFiles = numel(imDir);

% Making the dataset
for im = 1 : noFiles
    Img = imread(strcat(imagefiles_path, imDir(im).name));
    Img = rgb2gray(Img);

    % Detecting the corners using Shi - Tomasi Method
    corners = detectMinEigenFeatures(Img);
    cornerPix = uint16(corners.selectStrongest(numFeatures).Location);
    ImP = padarray(Img, [2 2]);
    lbpF = [];
    
%     Calculate the patch features 
    for pC = 1 : numFeatures
        center = cornerPix(pC, :);
        localBinaryPatternImage = zeros(3, 'uint8');
        

        for row = center(2) + 1: center(2) + 3
	        for col = center(1) + 1: center(1) + 3
		        centerPixel = ImP(row, col);
		        pixel7 = ImP(row-1, col-1) > centerPixel;
		        pixel6 = ImP(row-1, col) > centerPixel;
		        pixel5 = ImP(row-1, col+1) > centerPixel;
		        pixel4 = ImP(row, col+1) > centerPixel;
		        pixel3 = ImP(row+1, col+1) > centerPixel;
		        pixel2 = ImP(row+1, col) > centerPixel;
		        pixel1 = ImP(row+1, col-1) > centerPixel;
		        pixel0 = ImP(row, col-1) > centerPixel;
                
                eightBitNumber = uint8(...
			        pixel5 * 2^7 + pixel4 * 2^6 + ...
			        pixel3 * 2^5 + pixel2 * 2^4 + ...
			        pixel1 * 2^3 + pixel0 * 2^2 + ...
			        pixel7 * 2 + pixel6);

                localBinaryPatternImage(row - center(2) + 1, col - center(1) + 1) = eightBitNumber;
            end
        end
        
        feature = imhist(localBinaryPatternImage);

%         Concatenating all the patch level features
        lbpF = cat(1, feature, lbpF);
        
    end
    
%     Dataset of images with feature vectors
    X(im, :) = lbpF;
end


% Extracting the features for the search Image
I = imread(strcat(path, 'inputs\', ImName));
I = rgb2gray(I);

% Making the feature vector
corners = detectMinEigenFeatures(I);
cornerPix = uint16(corners.selectStrongest(numFeatures).Location);
ImP = padarray(I, [1 1]);
lbpFSI = [];

for pC = 1 : numFeatures
    center = cornerPix(pC, :);
    localBinaryPatternImage = zeros(3, 'uint8');
        

    for row = center(2) - 1: center(2) + 1
        for col = center(1) - 1: center(1) + 1
            centerPixel = ImP(row, col);
            
		    pixel7 = ImP(row-1, col-1) > centerPixel;
		    pixel6 = ImP(row-1, col) > centerPixel;
		    pixel5 = ImP(row-1, col+1) > centerPixel;
		    pixel4 = ImP(row, col+1) > centerPixel;
		    pixel3 = ImP(row+1, col+1) > centerPixel;
		    pixel2 = ImP(row+1, col) > centerPixel;
		    pixel1 = ImP(row+1, col-1) > centerPixel;
		    pixel0 = ImP(row, col-1) > centerPixel;
                
            eightBitNumber = uint8(...
                pixel5 * 2^7 + pixel4 * 2^6 + ...
			    pixel3 * 2^5 + pixel2 * 2^4 + ...
			    pixel1 * 2^3 + pixel0 * 2^2 + ...
			    pixel7 * 2 + pixel6);

            localBinaryPatternImage(row - center(2) + 1, col - center(1) + 1) = eightBitNumber;
        end
    end
        
    feature = imhist(localBinaryPatternImage);
    lbpFSI = cat(1, feature, lbpFSI);
end


newF = reshape(lbpFSI, [1, numFeatures*256]);

% K nearest neigbor search
idIms = knnsearch(X, newF, "K", k);

% Show the k-similar images
disp(idIms);

% Save and display the images
for n = 1:k
    I = imread(strcat(imagefiles_path, imDir(idIms(n)).name));
    imwrite(I, strcat(path, "Outputs\2019472_Q4\Im", int2str(n), ".jpg"));
    imshow(I);
    pause(2);

end