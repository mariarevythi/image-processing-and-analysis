clear 
clc 

% image import
X = imread('leaf.jpg');
figure; imshow(X);
title('εικόνα test');
impixelinfo;

I = rgb2gray(X);
figure; imshow(I);
title('εικόνα gray-scale');
impixelinfo;

A = imbinarize(I);
figure; imshow(A);
title('εικόνα binary');
impixelinfo;

A = imrotate( A , 90 ); %rotation
n=1000; %number of fourier Descriptors
%%  fourier Descriptors
fdes = FD1(A);
%% image restoration
B = iFD2(fdes,n,A);
figure; imshow(B);
title(' ανακατασκευασμένη εικόνα ');