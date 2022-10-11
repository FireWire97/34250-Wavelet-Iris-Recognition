%% IMAGE COMPRESSION AND WAVELETS EXAMPLES

clear all, close all, clc
G = imread('Figures/eye1.bmp');
%subplot(1,2,1)
imshow(G)
%G = rgb2gray(I);
%subplot(1,2,2)
%imshow(G)

%% Wavelet decomposition (2 level)
n = 2; w = 'bior3.5'; [C,S] = wavedec2(G,n,w); %Daubuchies 1 wavelet in this example

%% New section
% LEVEL 1
A1 = appcoef2(C,S,w,1); % Aproximation
[H1 V1 D1] = detcoef2('a',C,S,1); % Details
A1 = wcodemat(A1,128);
H1 = wcodemat(H1,128);
V1 = wcodemat(V1,128);
D1 = wcodemat(D1,128);

% LEVEL 2
A2 = appcoef2(C,S,w,2); % Aproximation
[H2 V2 D2] = detcoef2('a',C,S,2); % Details
A2 = wcodemat(A2,128);
H2 = wcodemat(H2,128);
V2 = wcodemat(V2,128);
D2 = wcodemat(D2,128);

dec2 = [A2 H2; V2 D2];
dec1 = [imresize(dec2,size(H1)) H1; V1 D1];
image(dec1);
colormap(flipud(gray))
axis off, axis tight
%set(gcf,'Position',[1750 100 1750 2000])

%% Wavelet Compression
% %[C,S]=wavedec2(G,4,'db1');
% Csort = sort(abs(C(:))); % Sort by magnitude
% 
% counter = 1;
% for keep = [.1 .05 .01 .003] % KEEP LARGEST .1 .05 ... WAVELET COEFFICIENTS AND THRESHOLD EVERYTHING ELSE AFTER 0
%     subplot(2,2,counter)
%     thresh = Csort(floor((1-keep)*length(Csort)));
%     ind = abs(C)>thresh;
%     Cfilt = C.*ind; % Threshold small indices
% 
%     % Plot reconstruction
%     Arecon = uint8(waverec2(Cfilt,S,w));
%     imshow(256-uint8(Arecon))  % Plot reconstruction
%     %title(
%     counter=counter+1;
% end
% %set


Csort = sort(abs(C(:))); % Sort by magnitude
keep = .03; % KEEP LARGEST .1 .05 ... WAVELET COEFFICIENTS AND THRESHOLD EVERYTHING ELSE AFTER 0
thresh = Csort(floor((1-keep)*length(Csort)));
ind = abs(C)>thresh;
Cfilt = C.*ind; % Threshold small indices
figure
subplot(121)
% Arecon_first = uint8(waverec2(C,S,w));
tryfirst = waverec2(C,S,w);
imshow(256-uint8(tryfirst))
subplot(122)
Arecon = uint8(waverec2(Cfilt,S,w));
imshow(uint8(Arecon))  % Plot reconstruction

%% PSNR
[peaksnr, snr] = psnr(Arecon, G);
imwrite(G, "eye1reconn.png",'PNG')
peaksnr
%% PNG vs BMP

B = imread('Figures/eye1.bmp');
P = imread('eye1reconn.png');
[peaksnr, snr] = psnr(P, B);
peaksnr

%% PSNR
%ref = imread('pout.tif');
%Gnoiz = imnoise(G,'salt & pepper', 0.02);

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