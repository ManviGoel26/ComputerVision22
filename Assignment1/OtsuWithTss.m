function[] = OtsuWithTss(name)

close all;
figure;

% Grayscale image
rgb = imread(name);
gray = rgb2gray(rgb);
imshow(gray);

% Histogram or Count of Pixels with each color.
index = [0:255]';
countOfPixels = imhist(gray);
result = zeros(size([1 256]));

for colorVal = 0 : 255
    valueSum1 = countOfPixels(1:colorVal).*index(1:colorVal);
    mean1 = sum(valueSum1)/sum(countOfPixels(1:colorVal));

    if (isnan(mean1) == 1)
        mean1 = 0;
    end
    
    tss1 = 0;
    
    if (mean1 ~= 0)
        for j = 1 : colorVal
            tss1 = tss1 + (countOfPixels(j) - mean1);
        end
    end

    valueSum2 = countOfPixels(colorVal+1:255).*index(colorVal+1:255);
    mean2 = sum(valueSum2)/sum(countOfPixels(colorVal+1:255));

    if (isnan(mean2) == 1)
        mean2 = 0;
    end

    tss2 = 0;

    if (mean2 ~= 0)
        for j = colorVal + 1:255
            tss2 = tss2 + (countOfPixels(j) - mean2);
        end
    end

    result(colorVal + 1) = tss1 + tss2;
end

% Finding Threshold by minimizing the sum of TSS
thresh = find(result == min(result));


disp(thresh)

% Finding the region of interest
valSum1 = sum(countOfPixels(1:thresh).*index(1:thresh));
valSum2 = sum(countOfPixels(thresh+1:255).*index(thresh+1:255));

% Displaying the Binary Mask
if (valSum1 > valSum2)
    imshow(gray > thresh)
else
    imshow(gray < thresh)
end

% Left: Saving the Values in a CSV file
end