function [eqImg, eqHist, histR, histG, histB, hist, cdf] = averageHistogramEqualization(img)
% Input: a rgb image (img)
% Output: an image equalized by the average histogram of R, G and B
% (eqImg) and its histogram (eqHist), the histograms of R, G and B (histR, histG and histB),
% the average histogram (hist) and the cumulative distribuction function vector (cdf)
% Preserves relevance of each channel on the histogram

    eqImg = zeros(size(img),class(img));
    h = size(img,1); 
    w = size(img,2); 
    nPixels = h * w;

    % Calculate the histogram on each channel separately 
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    histR = imhist(R, 256); % Histogram of red component
    histG = imhist(G, 256); % Histogram of green component
    histB = imhist(B, 256); % Histogram of blue component
    hist = zeros(256, 1); % Average histogram from the R, G and B histograms
    cdf = zeros(256, 1); % Cumulative distribuction function vector of the histogram
    eqHist = zeros(256, 1); % Equalized histogram
    
    count = 0;
    for i = 1:256
        hist(i) = double((histR(i) + histG(i) + histB(i))/3);
        count = count + hist(i);
        cdf(i) = count / nPixels;
        eqHist(i) = round(cdf(i) * 255);
    end

    % Apply this transformation to the R, G and B channels individually,
    % and again rebuild an RGB image from the processed channels.
    for r = 1:h
        for c = 1:w
            eqImg(r, c, 1) = eqHist(img(r, c, 1) + 1);
            eqImg(r, c, 2) = eqHist(img(r, c, 2) + 1);
            eqImg(r, c, 3) = eqHist(img(r, c, 3) + 1);
        end
    end

end

