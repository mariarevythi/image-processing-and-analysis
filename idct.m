close all
clear all
clc 

% διάβασμα εικόνας
s = load('barbara.mat');
X = s.barbara;
imshow(X);
title('Αρχική εικόνα');
impixelinfo;
I = double(rgb2gray(X));

% figure; imshow(X_1);
% X_2 = X(:,:,2);
% figure; imshow(X_2);
% X_3 = X(:,:,3);
% figure; imshow(X_3);
B = dct2(I);
figure;imshow(B);

i = iddct(iddct(B')');
figure;imshow(uint8(abs(i)));
  
   function IDCT=iddct(A) % idct
N=256;
C=zeros(N,2*N);
y=zeros(N,2*N);
Y=zeros(N,2*N);
IDCT=zeros(N,N);
A(:,1) = 2*sqrt(N) * A(:,1);
A(:,2:end) = sqrt(2*N) * A(:,2:end);  
C(1:256,1:256)=A;
%     for     n=1:2*N
        for k=1:2*N
            if k<=N 
                Y(:,k)=exp(1i*(k-1)*pi/(2*N))*C(:,k);
            elseif k==N+1 
                Y(:,k)=0;
            else
                Y(:,k)=-exp(1i*(k-1)*pi/(2*N))*C(:,2*N-k+2);
            end 
        end        
         y= ifft(Y,[],2);
         y = y(:,1:N);
%     end
     IDCT=y;
     IDCT = real(IDCT);

    
end


