function [cdfR, cdfG, cdfB] = histogramEqualization(img)
   
    nPixels = size(img,1) * size(img,2);
    % Calculate the histogram on each channel separately 
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    histR = imhist(R, 256); % Histogram of red component
    histG = imhist(G, 256); % Histogram of green component
    histB = imhist(B, 256); % Histogram of blue component
    
    cdfR = zeros(256, 1); % Cumulative distribuction function vector of the histogram
    cdfG = zeros(256, 1); % Cumulative distribuction function vector of the histogram
    cdfB = zeros(256, 1); % Cumulative distribuction function vector of the histogram
    
    countR = 0;
    countG = 0;
    countB = 0;
    for i = 1:256
        countR = countR + histR(i);
        countG = countG + histG(i);
        countB = countB + histB(i);
        cdfR(i) = countR / nPixels;
        cdfG(i) = countG / nPixels;
        cdfB(i) = countB / nPixels;
    end
    
end

