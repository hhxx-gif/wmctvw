
clear; close all; clc;

b2_values = [0.5, 2];  
colors = {[0.2, 0.4, 0.8], [0.8, 0.2, 0.2]};  

figure('Position', [100, 100, 600, 500], 'Name', 'MC罚函数3D视图', 'NumberTitle', 'off');

grid_max = 2.5;
[x1, x2] = meshgrid(linspace(-grid_max, grid_max, 100), linspace(-grid_max, grid_max, 100));


hold on;
for idx = 1:2
    b2 = b2_values(idx);
    threshold = 1/b2;  
    

    phi = @(x) (norm(x, 2) - (b2/2) * norm(x, 2)^2) .* (norm(x, 2) < threshold) + ...
               (1/(2*b2)) .* (norm(x, 2) >= threshold);
    

    phi_vals = zeros(size(x1));
    for i = 1:size(x1, 1)
        for j = 1:size(x1, 2)
            x = [x1(i, j); x2(i, j)];
            phi_vals(i, j) = phi(x);
        end
    end
    

    surf(x1, x2, phi_vals, ...
         'EdgeColor', 'none', ...
         'FaceAlpha', 0.9, ...
         'FaceColor', colors{idx});
    
   
end


xlabel('x_1', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('x_2', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('\phi(x)', 'FontSize', 12, 'FontWeight', 'bold');


grid on;
view(45, 30);  
shading interp;



hold off;
