function res = TIWDCT(blkSize, ovlp)


res.adjoint = 0;
res.blkSize = blkSize;
res.ovlp = ovlp;
res = class(res,'TIDCT');
