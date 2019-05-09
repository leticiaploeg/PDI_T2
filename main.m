%
% Universidade de Brasilia, PPGEE
% Image Processing, 1/2019
% 
% Histogram Specification/Matching based on existing image dataset
% Author: Leticia Camara van der Ploeg, 19/0005807

clear
close all
clc
%% Input image

prompt = '*** Histogram Specification ***\n\nInput image name (with extension): ';
imgFileName = input(prompt,'s');
while (exist(imgFileName, 'file') == 0)
    clc
    fprintf('\nFile %s does not exist. Try again.\n', imgFileName);
    prompt = '\nInput image name (with extension): ';
    imgFileName = input(prompt,'s');
end
inputImg = imread(imgFileName);

% Average Histogram Equalization
[eqImg, eqHist, histR, histG, histB, hist, cdf] = ...
    averageHistogramEqualization(inputImg);

% Histogram Equalization (independent channels)
[cdfR, cdfG, cdfB] = histogramEqualization(inputImg);

% Display original input image and histograms
figure 
subplot(2,3,[1 2]); 
imshow(inputImg); 
title('Input Image (Original)', 'FontSize', 14);
subplot(2,3,3);
bar(hist, 'k'); title('Average Histogram', 'FontSize', 14);
subplot(2,3,4);
bar(histR, 'r'); title('Histogram Red Channel', 'FontSize', 14);
subplot(2,3,5);
bar(histG, 'g'); title('Histogram Green Channel', 'FontSize', 14);
subplot(2,3,6);
bar(histB, 'b'); title('Histogram Blue Channel', 'FontSize', 14);

% Display equalized input image and equalized histograms
figure 
subplot(2,3,[1 2]); 
imshow(inputImg); 
title('Input Image after Histogram Equalization');
subplot(2,3,3);
bar(eqHist, 'k'); title('Equalized Average Histogram');
subplot(2,3,4);
bar(round(cdfR(:) * 255), 'r'); title('Equalized Histogram Red Channel');
subplot(2,3,5);
bar(round(cdfG(:) * 255), 'g'); title('Equalized Histogram Green Channel');
subplot(2,3,6);
bar(round(cdfB(:) * 255), 'b'); title('Equalized Histogram Blue Channel');


%% Dataset
% All images have 250x250 pixels

folder = '/Users/leticiacvdploeg/Documents/MATLAB/PDI_T2_HISTOGRAM_SPECIFICATION/dataset';
imgSet = imageSet(folder);

refImgCat = horzcat(read(imgSet, 1), read(imgSet, 2), read(imgSet, 3),...
        read(imgSet, 4), read(imgSet, 5), read(imgSet, 6));
%refImgCat = read(imgSet,1);

% Average Histogram Equalization
[eqRefImg, eqRefHist, histRefR, histRefG, histRefB, histRef, cdfRef] = ...
    averageHistogramEqualization(refImgCat);

% Histogram Equalization (independent channels)
[cdfRefR, cdfRefG, cdfRefB] = histogramEqualization(refImgCat);

% Display images from dataset and histogram
figure
subplot(2,3,[1 2 3]);
imshow(refImgCat);
title('Images from Dataset', 'FontSize', 14);
subplot(2,3,4);
bar(histRefR, 'r');
title('Histogram Red Channel', 'FontSize', 14);
subplot(2,3,5);
bar(histRefG, 'g');
title('Histogram Green Channel', 'FontSize', 14);
subplot(2,3,6);
bar(histRefB, 'b');
title('Histogram Blue Channel', 'FontSize', 14);

%% Histogram Specification/Matching

h = size(inputImg,1); 
w = size(inputImg,2);
specHist = zeros(256,1);
specHistR = zeros(256,1);
specHistG = zeros(256,1);
specHistB = zeros(256,1);

% Matches histogram with specified one (average)
for i = 1:256
    [~, idx] = min(abs(cdf(i)-cdfRef(:)));
    specHist(i) = idx - 1;
end

% Matches histogram with specified one (for each channel)
for i = 1:256
    [~, idxR] = min(abs(cdfR(i)-cdfRefR(:)));
    specHistR(i) = idxR - 1;
    
    [~, idxG] = min(abs(cdfG(i)-cdfRefG(:)));
    specHistG(i) = idxG - 1;
    
    [~, idxB] = min(abs(cdfB(i)-cdfRefB(:)));
    specHistB(i) = idxB - 1;
end

% Rebuilds the image with specified histogram
matchingImg = zeros(size(inputImg),class(inputImg));
for r = 1:h
    for c = 1:w
        matchingImg(r, c, 1) = specHistR(inputImg(r, c, 1) + 1);
        matchingImg(r, c, 2) = specHistG(inputImg(r, c, 2) + 1);
        matchingImg(r, c, 3) = specHistB(inputImg(r, c, 3) + 1);
    end
end

% Rebuilds the image with specified histogram (average)
matchingImgAverage = zeros(size(inputImg),class(inputImg));
for r = 1:h
    for c = 1:w
        matchingImgAverage(r, c, 1) = specHist(inputImg(r, c, 1) + 1);
        matchingImgAverage(r, c, 2) = specHist(inputImg(r, c, 2) + 1);
        matchingImgAverage(r, c, 3) = specHist(inputImg(r, c, 3) + 1);
    end
end

% Display figures and histograms
figure
subplot(2,3,1);
imshow(inputImg);
title('Input Image', 'FontSize', 14);

subplot(2,3,2);
imshow(matchingImg);
title('Histogram-matched Image', 'FontSize', 14);

subplot(2,3,3);
imshow(matchingImgAverage);
title('Histogram-matched Image using average RGB Histograms', 'FontSize', 14);

subplot(2,3,4);
area(histRefR, 'FaceColor', 'r'); hold on;
area(histRefG, 'FaceColor', 'g'); hold on;
a = area(histRefB, 'FaceColor', 'b');
title('Reference Histogram', 'FontSize', 14);
a.FaceAlpha = 0.6;

subplot(2,3,5)
area(imhist(matchingImg(:,:,1)), 'FaceColor', 'r'); hold on;
area(imhist(matchingImg(:,:,2)), 'FaceColor', 'g'); hold on;
a = area(imhist(matchingImg(:,:,3)), 'FaceColor', 'b');
title('Histogram of Histogram-Matched Image', 'FontSize', 14);
a.FaceAlpha = 0.6;

subplot(2,3,6)
area(imhist(matchingImgAverage(:,:,1)), 'FaceColor', 'r'); hold on;
area(imhist(matchingImgAverage(:,:,2)), 'FaceColor', 'g'); hold on;
a = area(imhist(matchingImgAverage(:,:,3)), 'FaceColor', 'b');
title('Histogram of Histogram-Matched Image (RGB Average)', 'FontSize', 14);
a.FaceAlpha = 0.6;
%% Histogram specification with Matlab function for comparison

result = imhistmatch(inputImg,refImgCat);
figure
subplot(1,3,1);
imshow(matchingImg);
title('My specification (RGB independent channels)', 'FontSize', 14);
subplot(1,3,2);
imshow(matchingImgAverage);
title('My specification (RGB average)', 'FontSize', 14);
subplot(1,3,3);
imshow(result);
title('Result for Matlab function imhistmatch', 'FontSize', 14);






