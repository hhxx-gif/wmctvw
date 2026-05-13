function  res = p2DFT(mask,imSize,phase,mode)



if nargin <3
	ph = 1;
end
if nargin <4
	mode = 2; 
end


res.adjoint = 0;
res.mask = mask;
res.imSize = imSize;
res.dataSize = size(mask);
res.ph = phase;
res.mode = mode;
res = class(res,'p2DFT');

