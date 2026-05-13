function X_out = explicit_wavelet_mctv_threshold(X_in, threshold, b_param, wavelet_type, wavelet_level)
    try
        [c, s] = wavedec2(X_in, wavelet_level, wavelet_type);
        
        for i = 1:length(c)
            coeff = c(i);
            
            if abs(coeff) > 1e-10
                b = b_param / threshold;
                if abs(coeff) < 1/(b^2)
                    S_b = 0.5 * b^2 * coeff^2;
                else
                    S_b = abs(coeff) - 1/(2*b^2);
                end
                
                phi_b = abs(coeff) - S_b;
                coeff_new = sign(coeff) * max(abs(coeff) - threshold * phi_b, 0);
                c(i) = coeff_new;
            end
        end
        
        X_out = waverec2(c, s, wavelet_type);
    catch
        X_out = X_in;
    end
end