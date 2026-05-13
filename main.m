clc; clear all; close all

I_org = imread('data/brain.bmp');
I_org = im2double(rgb2gray(I_org));

[m, n] = size(I_org);
scale = sqrt(m * n);

load Umask_random_110_01
R_0 = Umask;

R = fftshift(R_0);
Y = R.*fft2(I_org) / scale;

lamda_tv = 0.006;
lamda_wavelet = 0.002;
rho = 150;
numItr = 100;
rectol = 1e-4;

I_res = rec(R, Y, lamda_tv, lamda_wavelet, rho, numItr, rectol);

ReErr = norm(abs(I_org(:)) - abs(I_res(:))) / norm(abs(I_org(:)));
PSNR = psnr(I_org, abs(I_res));
SSIM = ssim(I_org, abs(I_res));

fprintf('Relative Error: %.4f\n', ReErr);
fprintf('PSNR: %.2f dB\n', PSNR);
fprintf('SSIM: %.4f\n', SSIM);

plot_results(R_0, I_res);