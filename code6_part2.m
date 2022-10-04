close all
clear 
clc 

% διάβασμα της εικόνας
X = imread('th_1202_16colors','jpg');
figure; imshow(X);
title('εικόνα test');
impixelinfo;

I = rgb2gray(X);
figure; imshow(I);

imds = imageDatastore('DataBase/*.jpg');
imgs = readall(imds);
%preview any image
% figure;imshow(imgs{34})

%% υπολογισμός dct
dct_test = dct2(I);
 figure;imshow(abs(dct_test));

 [m,n] = size(imgs);
dct_cell = cell(m,n);
for i=1:1:m
      a=dct2(rgb2gray(imgs{i}));
      image_dct = a;
 
     dct_cell{i} = image_dct;
    
end
%% τετραγωνικο σφάλμα
M=dct_test;
N=dct_cell{1};
err = immse(M,N);
index=1;
for i=2:1:m
    K=dct_cell{i};
      err2=immse(M,K);
      if err2<err
      err=err2;
      index=i;
      end
      
    
end
B=dct_cell{index};
% figure; imshow(rgb2gray(imgs{index}));

%% επιλογή συντελεστών με τη μέθοδο κατωφλίου

       t = 0.6;
       B(B<t) = 0;

    P = B; 

    %% εφαρμογή αντιστρόφου 
    idct = uint8(idct2( P ));
    figure;imshow(idct);
title('Ανακατασκευασμένη εικόνα με τη μέθοδο κατωφλίου');
err_1=immse(I,idct);


   
