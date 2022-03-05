function [] = m_2019472_q3(imName)

close all;
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment3\';

Image = imread(strcat(path, 'inputs\', imName));
Image = rgb2gray(Image);
nLoop = 100;

disp('Time taken to calculate SIFT features') 
tic 
for i = 1:nLoop
        pointsSift = detectSIFTFeatures(Image);
end
toc

disp(" ")
disp('Time taken to calculate SURF features')
tic 
 for i = 1:nLoop
        pointsSurf = detectSURFFeatures(Image);
 end
toc

figure, imshow(Image);
hold on;
plot(pointsSift.selectStrongest(10))


figure, imshow(Image);
hold on;
plot(pointsSurf.selectStrongest(10))

end