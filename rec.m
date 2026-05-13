function X = rec_nesterov_mctv_wavelet_l2_isotropic(R, Y, lamda_tv, lamda_wavelet, rho, numItr, rectol)
    [m, n] = size(Y);
    scale = sqrt(m * n);
    X  = zeros(m, n);
    Z = zeros(m, n, 2);
    U = zeros(m, n, 2);
    Z_wave = zeros(m, n);
    U_wave = zeros(m, n);
    
    X_nesterov = X;
    t = 1;
    t_prev = 1;
    
    prd = 1;
    Dx_kernel = psf2otf([prd, -prd], [m, n]);
    Dy_kernel = psf2otf([prd; -prd], [m, n]);
    uker = R + lamda_tv * rho * (abs(Dx_kernel).^2 + abs(Dy_kernel).^2) + ...
           lamda_wavelet * rho;

    it_num = 0;

    wavelet_type = 'db4';
    wavelet_level = 2;
    mctv_wave_b = 0.005;

    W = ones(m, n);
    W_prev = W;

    while it_num < numItr
        X_prev = X;
        
        div_ZU = dxt(Z(:,:,1) - U(:,:,1)) + dyt(Z(:,:,2) - U(:,:,2));
        RHS = ifft2(R.*Y) * scale + ...
              rho * lamda_tv * div_ZU + ...
              rho * lamda_wavelet * (Z_wave - U_wave);
        X = real(ifft2(fft2(RHS)./uker));
        
        if it_num > 0
            t_prev = t;
            t = 0.5 * (1 + sqrt(1 + 4 * t_prev^2));
            X_nesterov = X + ((t_prev - 1) / t) * (X - X_prev);
        else
            X_nesterov = X;
        end

        if it_num >= 1
            [Gx, Gy] = gradient(X_nesterov);
            grad_mag = sqrt(Gx.^2 + Gy.^2 + 1e-8);

            [Gx_fine, Gy_fine] = gradient(imgaussfilt(X_nesterov, 0.6));
            [Gx_coarse, Gy_coarse] = gradient(imgaussfilt(X_nesterov, 1.5));

            grad_mag_fine = sqrt(Gx_fine.^2 + Gy_fine.^2 + 1e-8);
            grad_mag_coarse = sqrt(Gx_coarse.^2 + Gy_coarse.^2 + 1e-8);

            try
                [c, s] = wavedec2(X_nesterov, wavelet_level, wavelet_type);
                texture_map = zeros(m, n);
                edge_map = zeros(m, n);

                for i = 1:wavelet_level
                    [H, V, D] = detcoef2('all', c, s, i);
                    if ~isempty(H)
                        H_resized = imresize(abs(H), [m, n], 'bilinear');
                        V_resized = imresize(abs(V), [m, n], 'bilinear');
                        D_resized = imresize(abs(D), [m, n], 'bilinear');

                        scale_power = 1.3^(wavelet_level - i);
                        texture_map = texture_map + (H_resized + V_resized) * scale_power;
                        edge_map = edge_map + D_resized * scale_power;
                    end
                end

                if max(texture_map(:)) > 0
                    texture_norm = texture_map / max(texture_map(:));
                    texture_weight = 0.88 + 0.12 * exp(-1.0 * texture_norm);
                else
                    texture_weight = ones(m, n);
                end

                if max(edge_map(:)) > 0
                    edge_norm = edge_map / max(edge_map(:));
                    edge_weight = 1 ./ (1 + 5 * edge_norm);
                else
                    edge_weight = ones(m, n);
                end

            catch
                texture_weight = ones(m, n);
                edge_weight = ones(m, n);
            end

            fine_weight = 1 ./ (1 + 10 * grad_mag_fine);
            coarse_weight = 1 ./ (1 + 4 * grad_mag_coarse);
            base_weight = 1 ./ (1 + 7 * grad_mag);

            W_new = base_weight .* fine_weight .* coarse_weight .* ...
                    texture_weight .* edge_weight;

            alpha = 0.8;
            W = alpha * W_new + (1-alpha) * W_prev;

            W = max(min(W, 2.2), 0.12);
            W_prev = W;
        end

        adaptive_b = mctv_wave_b * (0.99^min(it_num, 15));
        wave_threshold = lamda_wavelet/rho * (1 - 0.1 * min(it_num/20, 1));

        Tx = U(:,:,1) + dx(X_nesterov);
        Ty = U(:,:,2) + dy(X_nesterov);
        
        [Zx, Zy] = mctv_shrink(1/rho, Tx, Ty, W, adaptive_b);
        Z(:,:,1) = Zx;
        Z(:,:,2) = Zy;

        T_wave = U_wave + X_nesterov;
        Z_wave = wavelet_mctv_threshold(T_wave, wave_threshold, adaptive_b, wavelet_type, wavelet_level);

        U(:,:,1) = U(:,:,1) + (dx(X_nesterov) - Z(:,:,1));
        U(:,:,2) = U(:,:,2) + (dy(X_nesterov) - Z(:,:,2));
        U_wave = U_wave + (X_nesterov - Z_wave);

        if it_num > 0 && norm(X - X_prev) < rectol
            break;
        end
        
        it_num = it_num + 1;
    end
end