close all
clear all
clc 

% image import
s = load('tiger.mat');
X = s.tiger;
imshow(X);
title('original image');
impixelinfo;

%% white Gaussian noise
% tiger_noise=imnoise(X,'gaussian',0,0.03); % προσθήκη λευκού Gaussian θόρυβου
% figure;imshow(tiger_noise);
% title('εικόνα με γκαουσιανό θόρυβο');
% 
% av3=fspecial('average',3); %χρήση φίλτρου κινούμενου μέσου
% tiger_av=filter2(av3,tiger_noise);
% figure; imshow(tiger_av);
% title('η έξοδος του 3*3 φίλτρου κινούμενου μέσου');
% 
% figure; freqz2(av3) %απόκριση συχνότητας

v = var(X(:)) / 15; % SNR=15
tiger_gnoise = imnoise(X, 'gaussian', 0, v); % προσθήκη λευκού Gaussian θόρυβου
figure;imshow(tiger_gnoise);
title('image with white Gaussian noise');

av3=fspecial('average',3); %moving average filter
tiger_av=filter2(av3,tiger_gnoise);
figure;
subplot(2,1,1); imshow(tiger_av);
title('the output of moving average');

tiger_med=medfilt2(tiger_gnoise,[3 3]); %median filters
subplot(2,1,2); imshow(tiger_med);
title('output of median filter');

%% impulse noise
tiger_inoise=imnoise(X,'salt & pepper',0.2); % προσθήκη κρουστικού θόρυβου
figure;imshow(tiger_inoise);
title('image with impulse noise');

av3=fspecial('average',3); %moving average filter
tiger_av=filter2(av3,tiger_inoise);
figure; subplot(1,2,1); imshow(tiger_av);
title('the output of moving average filter');

tiger_med=medfilt2(tiger_inoise,[3 3]); %median filter
subplot(1,2,2); imshow(tiger_med);
title('the output of median filter');

% diff=double(tiger_med)-double(X);
% figure; imshow(diff);
% title('διαφορά 2 εικόνων');

%% white Gaussian noise and impulse noise
v = var(X(:)) / 15; % SNR=15
tiger_noise = imnoise(X, 'gaussian', 0, v); % προσθήκη λευκού Gaussian θόρυβου
figure;imshow(tiger_noise);
title('image with white Gaussian noise');

tiger_noise1=imnoise(tiger_noise,'salt & pepper',0.2); % προσθήκη κρουστικού θόρυβου
figure;imshow(tiger_noise1);
title('image with white Gaussian noise and impulse noise');

figure; subplot(1,3,1); imshow(X);
title('original image');

% av3=fspecial('average',3); %χρήση φίλτρου κινούμενου μέσου
% tiger_av=filter2(av3,tiger_noise1);
% subplot(1,3,2); imshow(tiger_av);
% title('χρήση φίλτρου κινούμενου μέσου');
% 
% tiger_med=medfilt2(tiger_av,[3 3]); %χρήση φίλτρο διαμέσου
%  subplot(1,3,3);imshow(tiger_med);
% title('χρήση και των 2 φίλτρων');

tiger_med=medfilt2(tiger_noise1,[3 3]); %χρήση φίλτρο διαμέσου
subplot(1,3,2); imshow(tiger_med);
title('the output of median filter');

av3=fspecial('average',3); %χρήση φίλτρου κινούμενου μέσου
tiger_av=filter2(av3,tiger_med);
subplot(1,3,3); imshow(tiger_av);
title('use of the two filters');



