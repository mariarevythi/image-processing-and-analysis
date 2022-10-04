function fdes = FD1(A)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


bdry_idx = bwboundaries(A);
idx_x = bdry_idx{1,1}(:,1);
idx_y = bdry_idx{1,1}(:,2);
idx_xn = (idx_x - mean(idx_x))/std(idx_x);
idx_yn = (idx_y - mean(idx_y))/std(idx_y);
idx = idx_xn + 1i*idx_yn;
fdes = fftshift(fft(idx));
end