close all
clear 
clc 

% image import
X = imread('moon','jpg');
figure; imshow(X);
title('original image');
impixelinfo;

X_1 = double(rgb2gray(X));
% X_1 = X(:,:,1);
% figure; imshow(X_1);
% X_2 = X(:,:,2);
% figure; imshow(X_2);
% X_3 = X(:,:,3);
% figure; imshow(X_3);

%% linear transform so as to span the available dynamic range [0:255].
l=min(min(X_1)); 
L=max(max(X_1));
N=255;
n=0; %οταν εβγαλα το double to k pantou 0
G=((double(X_1)-double(L))/(double(L)-double(l)))*(N-n)+n; %g(x,y)=(N-n)*{f(x,y)-L}/{L-l}+n

% transfer of the frequency point (0,0) to the center of the field.
K=zeros(256,256);
for x=1:256
    for y=1:256 
        K(x,y)=G(x,y)*(-1)^(x+y);
    end    
end
P=K;

%%  Computation of the two-dimensional DFT with the lines-columns method

image_fft =  fft(fft(P).').';
g=abs(image_fft);  %γραμμική απεικόνιση πλάτους του μετασχηματισμού της εικόνας
figure; subplot(2,1,1); 
imagesc(g) ;
colormap(gray);
title('linear width illustration');

l=abs(log(g)+1);  %λογαριθμική απεικόνιση πλάτους του μετασχηματισμού της εικόνας
subplot(2,1,2); 
imagesc(l) ;
colormap(gray);
title('logarithmic width illustration');

% figure; surf(g);
% title('platos fasmatos');

%% use of a low-pass filter

[M, N] = size(P);
n = 2; % filter class
D0 = 600; % cut-off frequency
% design of  LP Butterworth filter
u = 0:(M-1);
v = 0:(N-1);
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;
[V, U] = meshgrid(v, u); % MATLAB library function meshgrid(v, u) returns 2D grid which contains the coordinates of vectors  v and u. 
D = sqrt(U.^2 + V.^2);
H = 1./(1 + (D./D0).^(2*n));
fil = H.*image_fft;

%% Application of 2D inverse DFT

[M, N] = size(fil);
    ifft_c = ifft(fil);
    ifft_r = ifft( ifft_c,N,2);

%     ifft_r=ifft2(fil);
      % inverse procedure  to recover point
A=zeros(256,256);
for x=1:256
    for y=1:256 
        A(x,y)= ifft_r(x,y)*(-1)^(x+y);
    end    
end

figure; imagesc(abs(A));
% figure;imagesc(A)
colormap(gray)
title('final image');

