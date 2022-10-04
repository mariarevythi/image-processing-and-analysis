close all
clear 
clc 

% image import
X = imread('lenna','jpg');
figure; imshow(X);
title('original image');
impixelinfo;

X_1 = X(:,:,1);
% figure; imshow(X_1);
X_2 = X(:,:,2);
% figure; imshow(X_2);
X_3 = X(:,:,3);
% figure; imshow(X_3);

lenna=im2double(X_1); %μετατροπή του πίνακα απο uint8 σε double

Y=psf(lenna);
figure, imshow(Y);
title('image after the application of the transformation');

%% impulse response
% d=zeros(size(Y));
% d(1,1)=1; 
% h=conv2(Y,d);
% H =  fft(fft(h).').'; % υπολογισμός του fft
% figure, imagesc(abs(H))
% colormap(gray)
% 
% figure; imshow(freqz2(abs(H)));

% h=conv2(Y,lenna);
% H =  fft(fft(h).').'; % υπολογισμός του fft
% % figure; imshow(freqz2(abs(H)));
% figure, imagesc(abs(H))

d=zeros(size(Y));
d(1,1)=1; 

h=psf(d);
%  H=fft(h);
 H=fft(fft(h).').';
figure, imagesc(abs(H));
colormap(gray);
title('impulse respone');
% figure; imshow(abs(H));


%%  application of the inverse filter at frequency domain with threshold
 eisod=fft(fft(lenna).').';
  exod=fft(fft(Y).').';
B=exod./eisod; %προσδιορισμός του Β
H=zeros(size(B));
g=7; % threshold

for i=1:size(H,1)
    for j=1:size(H,2)
        if 1/(abs(B(i,j)))<g
            H(i,j)=1/B(i,j);
        else
            H(i,j)=g*(abs(B(i,j)))/B(i,j);
        end
        
    end
end    

I=H.*exod;
i=ifft2(I);
 i_1=abs(i);
figure,imshow(i_1);
title(' final image ');
 
err = immse(lenna, i_1); %mean square error
fprintf('\n The mean-squared error is %0.4f\n', err);

th = [0.01 0.5 2 7 10]; 
err = [0.2585 0.009 0.003 0.0001 0.0001]; 
 figure; plot(th,err);


