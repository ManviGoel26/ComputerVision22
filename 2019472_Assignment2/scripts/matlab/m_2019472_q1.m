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

function [m1, mask1] = sepMeasure(sm)
    sm = double(sm)/255;
    mask1 = imbinarize(double(sm), graythresh(sm));
    
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
    
    x = linspace(0, 1, 256);
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
    m1 = 1/(1+log10(1+sum(fg1(x<rtx))+sum(fg2(x>=rtx))));

end

function m2 = conMeasure(mask)
    maskD = double(mask);
    CC = bwconncomp(maskD);
    OS = CC.NumObjects;
    numPixels = cellfun(@numel,CC.PixelIdxList);

    sumCC = 0;

    for j = 1:OS
        sumCC = sumCC + numPixels(j);
    end
    CPrimeS = max(numPixels)/sumCC;
    m2 = CPrimeS + (1-CPrimeS)/(OS);
end

fid = fopen(strcat(path, 'Outputs\2019472_Q1.csv'), 'w' );

for im = 1 : noFiles
    
    s = size(imDirNDL(im).name);
    newStr = extractBetween(imDirNDL(im).name, 9, s(2)-4);
    newStr = newStr{1};
    
    disp(strcat("Image: ", newStr));

    smNDL = imread(strcat(imagefiles_pathNDL, imDirNDL(im).name));
    smDL = imread(strcat(imagefiles_pathDL, imDirDL(im).name));


    % First quality measure
    [m1DL, maskDL] = sepMeasure(smDL);
    [m1NDL, maskNDL] = sepMeasure(smNDL);
    
    disp("The separation measures for the DL based and Non DL based saliency maps")
    disp(m1DL);
    disp(m1NDL);

    % Second Quality Measure
    m2DL = conMeasure(maskDL);
    m2NDL = conMeasure(maskNDL);
    
    
    disp("The concentration measures for the DL based and Non DL based saliency maps")
    disp(m2DL);
    disp(m2NDL);

    outputs = [m1DL m1NDL m2DL m2NDL];
    fprintf(fid, '%s, %f, %f, %f, %f\n', newStr, outputs(1), outputs(2), outputs(3), outputs(4));
end

fclose(fid);
end






