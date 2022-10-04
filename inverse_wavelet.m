%% IMAGE COMPRESSION AND WAVELETS EXAMPLES

clear all, close all, clc
I = imread('figures/retina1.ppm');
subplot(2,2,1)
imshow(I)
G = rgb2gray(I);
subplot(2,2,2)
imshow(G)

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
keep = .1; % KEEP LARGEST .1 .05 ... WAVELET COEFFICIENTS AND THRESHOLD EVERYTHING ELSE AFTER 0
thresh = Csort(floor((1-keep)*length(Csort)));
ind = abs(C)>thresh;
Cfilt = C.*ind; % Threshold small indices
subplot(223)
% Arecon_first = uint8(waverec2(C,S,w));
tryfirst = waverec2(C,S,w);
%imshow(256-uint8(tryfirst))
imshow(uint8(tryfirst))
subplot(224)
Arecon = uint8(waverec2(Cfilt,S,w));
imshow(256-uint8(Arecon))  % Plot reconstruction

%% PSNR
%ref = imread('pout.tif');
%Gnoiz = imnoise(G,'salt & pepper', 0.02);

[peaksnr, snr] = psnr(uint8(tryfirst), G);
  
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);

[peaksnr___, snr___] = psnr(uint8(Arecon),G);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr___);