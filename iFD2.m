function B = iFD2(fdes,n,A)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
bdry_idx = bwboundaries(A);
idx_x = bdry_idx{1,1}(:,1);
idx_y = bdry_idx{1,1}(:,2);
N = numel(idx_x);
% n = (N/r);
nstart = floor(N/2)-floor(n/2)+1;
nend = floor(N/2)+floor(n/2)+1;
if nend>N
    nend = N;
end
[h,w] = size(A);


fdes_lp = ifftshift([zeros(nstart-1,1);fdes(nstart:nend);zeros(N-nend,1)]);
fshape_z = ifft(fdes_lp);
fshape_x = real(fshape_z);
fshape_y = imag(fshape_z);
fshape_x = (fshape_x-mean(fshape_x))/std(fshape_x);
fshape_y = (fshape_y-mean(fshape_y))/std(fshape_y);
fshape_x = nearest(mean(idx_x)+fshape_x*std(idx_x));
fshape_y = nearest(mean(idx_y)+fshape_y*std(idx_y));

B = zeros(h,w);
fdes_idx = sub2ind(size(A),fshape_x,fshape_y);
B(fdes_idx) = 1;

end