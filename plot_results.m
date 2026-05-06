function plot_results(R_0, I_res)
    figure('Position', [100, 100, 600, 300], 'Color', 'white');
    
    subplot(1, 2, 1);
    imshow(abs(R_0));
    title('Sampling Mask', 'FontSize', 12, 'FontWeight', 'bold');
    axis off;
    colormap(gca, 'gray');
    colorbar;
    
    subplot(1, 2, 2);
    I_res_display = abs(I_res);
    imshow(I_res_display);
    title('Reconstructed Image', 'FontSize', 12, 'FontWeight', 'bold');
    axis off;
    colormap(gca, 'gray');
    colorbar;
    
    sgtitle('MRI Reconstruction Results - Nesterov MCTV-Wavelet-L2', 'FontSize', 14, 'FontWeight', 'bold');
end