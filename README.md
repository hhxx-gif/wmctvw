Nonconvex Multi-Regularization Framework for Detail-Preserving Undersampled MRI Reconstruction

1 Overview

This repository provides an implementation of an MRI reconstruction algorithm based on nonconvex multi-regularization. The method integrates:

Nonconvex Total Variation (MCTV)
Wavelet-domain sparsity
Adaptive weighting strategy
Nesterov momentum acceleration

It is designed to reconstruct high-quality images from undersampled k-space data while preserving fine details and suppressing artifacts

2 Runtime Environment and Dependencies
2.1 Software Environment
MATLAB R2021b or higher

2.2 Hardware Environment
CPU: Intel i5 or above
Memory: 8GB or more
GPU support not required

3 Data and Sampling Mask
Data

The experiments are conducted on a grayscale brain angiography image:

File: data/Brain angiography.jpg
The image is normalized to double precision before processing.

Users can replace this image with other MRI datasets if needed.
Sampling Mask

A Cartesian undersampling pattern is used to simulate k-space acquisition:

File: data/Umask_Cartesian_100.mat

Description: Cartesian mask with 100 sampled phase-encoding lines
The current implementation uses Cartesian sampling
Other sampling patterns (e.g., radial or random) can be incorporated by modifying the mask
Sampling rate can be adjusted by changing the number of acquired lines

 Implementation Details

Initialization

The reconstruction is initialized using zero-filled inverse Fourier transform
All auxiliary variables are initialized to zero

Key Parameters

lamda_tv: controls the strength of total variation regularization
lamda_wavelet: controls the wavelet regularization
rho: ADMM penalty parameter
numItr: number of iterations
