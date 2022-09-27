I = imread('Bliss.png');
G = rgb2gray(I)
imshow(G)
% imshow(I)
% figure
% imhist(I)
[CA,CD] = dwt(G(1,:),'bior3.5');