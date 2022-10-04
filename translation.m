clear 
clc 

% image import
X = imread('leaf.jpg');
figure; imshow(X);
title('original image');
impixelinfo;

I = rgb2gray(X);
figure; imshow(I);
title(' gray-scale iamge');
impixelinfo;

A = imbinarize(I);
figure; imshow(A);
title(' binary image');
impixelinfo;

A = imtranslate(A,[40, 50]); %translation
n=1500;  %number of fourier Descriptors
%%  fourier descriptors
fdes = FD1(A);
%% image restoration
B = iFD2(fdes,n,A);
figure; imshow(B);
title(' reconstructed image ');