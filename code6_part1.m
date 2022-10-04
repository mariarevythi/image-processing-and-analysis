close all
clear 
clc 

% image import
X = imread('th_2146.jpg','jpg');
figure; imshow(X);
title('image test');
impixelinfo;

I = rgb2gray(X);
figure; imshow(I);

imds = imageDatastore('DataBase/*.jpg');
imgs = readall(imds);
%preview any image
% figure;imshow(imgs{34})
%% histograms
figure; imhist(I);

%%
[m,n] = size(imgs);
hist_cell = cell(m,n);
for i=1:1:m
      a=rgb2gray(imgs{i});
      image_hist = imhist(a);
 
     hist_cell{i} = image_hist;
    
end
% A = cell2mat(hist_cell);
%% mean squared error
M=imhist(I);
N=hist_cell{1};
err = immse(M,N);
index=1;
for i=2:1:m
    K=hist_cell{i};
      err2=immse(M,K);
      if err2<err
      err=err2;
      index=i;
      end
      
    
end
B=hist_cell{index};
figure; imshow(rgb2gray(imgs{index}));
