close all
clear 
clc 

% διάβασμα της εικόνας
X = imread('lenna','jpg');
 subplot(1,2,1);imshow(X);
title('Original image');
impixelinfo;

X_1 = X(:,:,1);
lenna=im2double(X_1); %μετατροπή του πίνακα απο uint8 σε double
%% white Gaussian noise
n=randn(257,255);
v = var(lenna(:)) / 10; % SNR=10
g=lenna+v^0.5*n;
subplot(1,2,2); imshow(g);
title('εικόνα με θόρυβο');
impixelinfo;

%% remove image noise assuming the power of noise is known.
%step 1
ge = padarray(g,[257 259],0,'post'); %zero padding στο g
%step 2
m = mean(g(:));
ge1=ge-m; %αφαίρεση μg
G =  fft(fft(ge1).').'; %υπολογισμός του G μέσω του 2D-FFT
%step 3
lenna_p = padarray(g,[257 259],0,'post'); %zero padding στh lenna
n_p = padarray(n,[257 259],0,'post'); %zero padding στο θόρυβο

N1=size(lenna_p);

lenna_fft= fft(fft(lenna_p).').';
n_fft= fft(fft(n_p).').';

Pf=(abs(lenna_fft)).^2;
Pn=(abs(n_fft)).^2;

H=Pf./(Pf+Pn); % υπολογισμός του H(u,v)
%step 4
fe=ifft2(H.*G); % υπολογισμός του ifft
%step 5
f=zeros(257,255); %Αφαίρεση Zero-padding
f(1:257,1:255)=fe(1:257,1:255);
f1=f+m; %προσθήκη μg
%step 6
figure; imshow(abs(f1));
title('final image assuming the power of noise is known ');
% lenna_new=wiener2(g, [5 5]); %εφαρμογή φίλτρου wiener
% figure; imshow(lenna_new);
% title('η έξοδος του φίλτρου wiener')

%% remove noise assuming the power of noise is unknown.
%step 1
ge = padarray(g,[257 259],0,'post'); %zero padding στο g
%step 2
m = mean(g(:));
ge1=ge-m; %αφαίρεση μg
G =  fft(fft(ge1).').'; %υπολογισμός του G μέσω του 2D-FFT
%step 3
lenna_p = padarray(g,[257 259],0,'post'); %zero padding στh lenna
lenna_fft= fft(fft(lenna_p).').';
Pf=(abs(lenna_fft)).^2;
%υπολογισμος pn
image_fft =  fft(fft(g).').';
platos=abs(image_fft); 
window_size_x = 15;
window_size_y = 15;
window = abs(platos(1:window_size_x,1:window_size_y));
Pn = mean(mean(window)) / (window_size_x*window_size_y);
% figure; imshow(platos);
% title('γραμμική απεικόνιση πλάτους του μετασχηματισμού της εικόνας g ');
H=Pf./(Pf+Pn); % υπολογισμός του H(u,v)
%step 4
fe=ifft2(H.*G); % υπολογισμός του ifft
%step 5
f=zeros(257,255); %Αφαίρεση Zero-padding
f(1:257,1:255)=fe(1:257,1:255);
f1=f+m; %προσθήκη μg
%step 6
figure; imshow(abs(f1));
title('final image assuming the power of noise is unknown ');





