% Load an image
clear all, close all, clc
I = imread('Figures/xmix.jpeg');
G = rgb2gray(I);

% calculate the psnr vs. bpp
peaksnrArray = zeros(1,100);
bppArray = zeros(1,100);
    
for i=1:100
    imwrite(G,'Figures/xmixCompressed.jpeg','Quality',i,'Mode','lossy');
    compressedG = imread('Figures/xmixCompressed.jpeg');
    [peaksnr, snr] = psnr(compressedG, G);
    peaksnrArray(i) = peaksnr;
    imgPath = dir('Figures/xmixCompressed.jpeg');         
    filesize = imgPath.bytes;
    bppArray(i) = filesize;
end

plot(bppArray, peaksnrArray, 'Linewidth', 4)
grid on
title('Image quality loss with different compression rates')
xlabel('Filesize in bytes') 
ylabel('PSNR value') 