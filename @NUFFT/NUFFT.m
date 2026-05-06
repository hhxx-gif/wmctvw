function  res = NUFFT(k,w,phase,shift,imSize, mode)


if exist('nufft') <2
	error('must have Jeffery Fessler''s NUFFT code in the path');
end

    om = [real(k(:)), imag(k(:))]*2*pi;
    Nd = imSize;
    Jd = [6,6];
    Kd = [Nd*2];
    n_shift = Nd/2 + shift;
    res.st = nufft_init(om, Nd, Jd, Kd, n_shift);

    res.phase = phase;
    res.adjoint = 0;
    res.imSize = imSize;
    res.dataSize = size(k);
    res.w = w;
    res.mode = mode;
    res = class(res,'NUFFT');

