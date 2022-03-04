function [] = m_2019472_q3(imName)

close all;
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';

Image = imread(strcat(path, 'inputs\', imName));
Image = rgb2gray(Image);
nLoop = 7e7;

function pointsSift = funcSift(Image, nLoop) 
    for i = 1:nLoop
        pointsSift = @() detectSIFTFeatures(Image);
    end
end


function pointsSurf = funcSurf(Image, nLoop) 
    for i = 1:nLoop
        pointsSurf = @() detectSURFFeatures(Image);
    end
end

f1 = @() funcSift(Image, nLoop);
f2 = @() funcSurf(Image, nLoop);
t = timeit(f1, 1)
t = timeit(f2, 1)

% imshow(Image);
% hold on;
% plot(points.selectStrongest(10))
end