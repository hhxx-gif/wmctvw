function [Zx, Zy] = explicit_mctv_shrink(threshold, Tx, Ty, W, b_param)
    [m, n] = size(Tx);
    
    max_iter = 20;
    tol = 1e-6;
    
    Zx = zeros(m, n);
    Zy = zeros(m, n);
    
    for iter = 1:max_iter
        Zx_old = Zx;
        Zy_old = Zy;
        Z_mag = sqrt(Zx.^2 + Zy.^2 + 1e-8);
        
        b = b_param / threshold;
        
        mask_small = Z_mag < 1/(b^2);
        mask_large = ~mask_small;
        
        grad_S_b_x_small = b^2 * Zx;
        grad_S_b_y_small = b^2 * Zy;
        
        Z_mag_large = max(Z_mag, 1e-8);
        grad_S_b_x_large = Zx ./ Z_mag_large;
        grad_S_b_y_large = Zy ./ Z_mag_large;
        
        grad_S_b_x = mask_small .* grad_S_b_x_small + mask_large .* grad_S_b_x_large;
        grad_S_b_y = mask_small .* grad_S_b_y_small + mask_large .* grad_S_b_y_large;
        
        grad_phi_b_x = Zx ./ max(Z_mag, 1e-8) - grad_S_b_x;
        grad_phi_b_y = Zy ./ max(Z_mag, 1e-8) - grad_S_b_y;
        
        Wx = Tx + threshold * b_param * grad_phi_b_x;
        Wy = Ty + threshold * b_param * grad_phi_b_y;
        
        W_mag = sqrt(Wx.^2 + Wy.^2 + 1e-8);
        shrink_factor = max(1 - threshold * W ./ (W_mag + 1e-8), 0);
        
        Zx = shrink_factor .* Wx;
        Zy = shrink_factor .* Wy;
        
        diff = sqrt(sum((Zx(:) - Zx_old(:)).^2 + (Zy(:) - Zy_old(:)).^2));
        if diff < tol
            break;
        end
    end
end