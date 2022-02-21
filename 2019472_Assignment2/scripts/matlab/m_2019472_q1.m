function[] = m_2019472_q1()

close;

% Making the features dataset using the image dataset.
% Loading the images. Specify the variable values. 
path = 'C:\Users\hp\Desktop\Manvi\Semesters\6th_WinterSemester\ComputerVision\ComputerVision22\2019472_Assignment2\';
imagefiles_pathDL = strcat(path, 'inputs\Q1_DL\');
imagefiles_pathNDL = strcat(path, 'inputs\Q1_NonDL\');

imDirDL = dir([imagefiles_pathDL '*.png']);
imDirNDL = dir([imagefiles_pathNDL '*.jpg']);
noFiles = numel(imDirDL);

function [m1, fg] = sepMeasure(sm)
    thresh = graythresh(sm)*255;
    mask1 = sm>thresh;
    mask2 = sm<thresh;
    pc1 = sum(mask1);
    pc2 = sum(mask2);

    if (pc1 > pc2)
        
        fg = sm;
        fg(~mask1) = 0;
        bg = sm;
        bg(~mask2) = 0;
    else
        fg = sm;
        fg(~mask2) = 0;
        bg = sm;
        bg(~mask1) = 0;
    end
    
    fg = double(fg)/255;
    bg = double(bg)/255;
    meanFG = mean2(fg);
    stdFG = std2(fg);
    meanBG = mean2(bg);
    stdBG = std2(bg);
    
    disp("The means")
    disp(meanFG);
    disp(meanBG);    
    disp done
    x = [0:0.001:1];
    fgD = normpdf(x, meanFG, stdFG);
    bgD = normpdf(x, meanBG, stdBG);
    zPrimeP = (meanBG*(stdFG^2) - meanFG*(stdBG^2))/(stdFG^2-stdBG^2) + ((stdFG*stdBG)/(stdFG^2 - stdBG^2))*((meanFG^2 - meanBG^2)^2 - 2*(stdFG^2 - stdBG^2)*(log(stdBG)-log(stdFG)))^0.5;
    zPrimeN = (meanBG*(stdFG^2) - meanFG*(stdBG^2))/(stdFG^2-stdBG^2) - ((stdFG*stdBG)/(stdFG^2 - stdBG^2))*((meanFG^2 - meanBG^2)^2 - 2*(stdFG^2 - stdBG^2)*(log(stdBG)-log(stdFG)))^0.5;
    array = [0 1];
    if (zPrimeN > 0)
        array(3) = zPrimeN;
    end
    if (zPrimeP > 0)
        array(4) = zPrimeP;
    end

    arraySort = sort(array);
    Ls = 0;
    
    for i = 1:1001
        Ls = Ls + 0.001*min(fgD(i), bgD(i));
    end
    disp(Ls)
    m1 = 1/(1+log10(1+1000*Ls));
end

function m2 = conMeasure(fg)
    CC = bwconncomp(fg);
    OS = CC.NumObjects;
    numPixels = cellfun(@numel,CC.PixelIdxList);
    sumCC = 0;

    for j = 1:OS
        sumCC = sumCC + numPixels(j);
    end
    CPrimeS = max(numPixels)/sumCC;
    m2 = CPrimeS + (1-CPrimeS)/(OS);
end

for im = 1 : noFiles
    disp(imDirNDL(im).name);
    smNDL = imread(strcat(imagefiles_pathNDL, imDirNDL(im).name));
    smDL = imread(strcat(imagefiles_pathDL, imDirDL(im).name));

    % First quality measure
    [m1DL, fgDL] = sepMeasure(smDL);
    [m1NDL, fgNDL] = sepMeasure(smNDL);
    
    disp("The separation measures for the DL based and Non DL based saliency maps")
    disp(m1DL);
    disp(m1NDL);

    % Second Quality Measure
    m2DL = conMeasure(fgDL);
    m2NDL = conMeasure(fgNDL);
    
    
    disp("The concentration measures for the DL based and Non DL based saliency maps")
    disp(m2DL);
    disp(m2NDL);


    outputs(im, :) = [m1DL m1NDL m2DL m2NDL];
    writematrix(outputs, strcat(path, 'Outputs\2019472_Q1.csv')); 
end



end






