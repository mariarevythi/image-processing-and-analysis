close all
clear all
clc 

% image import
s = load('barbara.mat');
X = s.barbara;
figure; imshow(X);
 title('original image');
impixelinfo;
Image = double(rgb2gray(X));
% figure; imshow(Image);


% figure; imshow(I);
% X_1 = X(:,:,1);
% figure; imshow(X_1);
% X_2 = X(:,:,2);
% figure; imshow(X_2);
% X_3 = X(:,:,3);
% figure; imshow(X_3);

%% division of the image to non-overlapping sub-images of size 32x32
% Image = im2double(I,256);
[m,n] = size(Image);
Blocks = cell(m/32,n/32);
counti = 0;
for i = 1:32:m-31
   counti = counti + 1;
   countj = 0;
   for j = 1:32:n-31
        countj = countj + 1;
        Blocks{counti,countj} = Image(i:i+31,j:j+31);
   end
end
%% computation of 2D-DCT for each sub-image
DCT_cell = cell(m/32,n/32);
for i=1:1:8
    for j=1:1:8
      a=Blocks{i,j};  
%       dct_1d=ddct(a);      
%       image_dct2d=ddct(dct_1d.');
%       image_dct=image_dct2d.';
      image_dct =  ddct(ddct(a).').';
       DCT_cell{i,j} = image_dct;
     
    end
end
A = cell2mat(DCT_cell);
% figure;imshow(abs(A));
% title('Μετασχηματισμός DCT');
% B = dct2(A);
% figure;imshow(abs(A));
% isequal(A,B)

%% Zone method
factor_cell = cell(m/32,n/32);
for i=1:1:8
    for j=1:1:8
       Cell= DCT_cell{i,j};

      for a=1:32
           for b=1:32 %32*32=1024
               if a>14 || b>14 %20 τοις 100 πληροφορια
                   Cell(a,b)=0; 
               end 
                
           end 
%            factor_cell{i,j} = Cell;    
      end
       factor_cell{i,j} = Cell;   
    end 
   
end 
%  IDCT transform
IDCT_cell = cell(m/32,n/32);
for i=1:1:8
    for j=1:1:8
      a=factor_cell{i,j};  
%       [M, N] = size(a);
%     iddct_c = iddct(a);
%     iddct_r = iddct( iddct_c);
image_idct = iddct(iddct(a')');
       IDCT_cell{i,j} =image_idct ;
     
    end
end
% reunification
A = cell2mat(IDCT_cell);
figure;imshow(uint8(abs(A)));
title('reconstructed image with Zone method')
err1 = immse(A,Image);

%% Threshold method
factor_cell = cell(m/32,n/32);
for i=1:1:8
    for j=1:1:8
%        output=zeros(32,32); 
       Cell= DCT_cell{i,j}; 
       output = zeros(32);
for c = 1:204
    [x_1,y_1] = max(max(Cell));
    [x_2,y_2] = max(Cell(:,y_1));
    output(y_2, y_1) = Cell(y_2,y_1);
    Cell(y_2,y_1) = -inf;
end

    factor_cell{i,j} = abs(output); 

    end 
end
%  IDCT transform
IDCT_cell = cell(m/32,n/32);
for i=1:1:8
    for j=1:1:8
      a=factor_cell{i,j};  
%       [M, N] = size(a);
%     iddct_c = iddct(a);
%     iddct_r = iddct( iddct_c);
image_idct = iddct(iddct(a')');
       IDCT_cell{i,j} = image_idct;
     
    end
end
% reunification
A2 = cell2mat(IDCT_cell);
figure;imshow(uint8(abs(A2)));
title('reconstructed image with Threshold method  ');
err2 = immse(A2,Image);
% subplot(2,1,1); imshow(uint8(abs(A2)));
% title('Ανακατασκευασμένη εικόνα με τη μέθοδο κατωφλίου');
% subplot(2,1,2); imshow(uint8(abs(A)));
% title('Ανακατασκευασμένη εικόνα με τη μέθοδο ζώνης')

% curve f the mean square error between the initial image and the reconstructed image
r = [5 10 20 30 40 50]; 
err2 = [726 693 670 663 661 660]; 
 figure; plot(r,err2);

hold on 
err1=[373 307 260 200 191 152];
plot(r,err1);
hold off


function DCT=ddct(A) %dct
N=32;
x=zeros(N,2*N);
y=zeros(N,2*N);
Y=zeros(N,2*N);
DCT=zeros(N,N);
x(1:32,1:32)=A;
        
     for k=1:2*N
         y(:,k)=x(:,k)+x(:,2*N+1-k);
     end
     
 Y =fft(y,[],2);                    
Y = Y(:,1:N);
c = 0:N-1;
s =(exp(-j*(c)*pi/(2*N)));
DCT=s.*Y;
DCT = real(DCT);
DCT(:,1) = 1/(2*sqrt(N)) * DCT(:,1);
DCT(:,2:end) = 1/sqrt(2*N) * DCT(:,2:end);  
end

    function IDCT=iddct(A) % idct
N=32;
C=zeros(N,2*N);
y=zeros(N,2*N);
Y=zeros(N,2*N);
IDCT=zeros(N,N);
A(:,1) = 2*sqrt(N) * A(:,1);
A(:,2:end) = sqrt(2*N) * A(:,2:end);  
C(1:32,1:32)=A;
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








