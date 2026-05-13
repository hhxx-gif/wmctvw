
clear; close all; clc;


phi = @(x) (norm(x, 2) - (1/2) * norm(x, 2)^2) .* (norm(x, 2) < 1) + ...
           (1/2) .* (norm(x, 2) >= 1);
figure('Position', [100, 100, 1400, 450], 'Name', 'MC罚函数的非凸性分析', 'NumberTitle', 'off');

subplot(1, 3, 1);
t = linspace(0, 2, 400);
phi_t = (t - 0.5*t.^2) .* (t < 1) + 0.5 .* (t >= 1);

plot(t, phi_t, 'b-', 'LineWidth', 3);
hold on;


plot([1, 1], [0, 0.6], 'k--', 'LineWidth', 1);

xlabel('t = ||x||₂', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('φ(t)', 'FontSize', 12, 'FontWeight', 'bold');

grid on;


ax1 = gca;
ax1.XAxisLocation = 'origin';  
ax1.YAxisLocation = 'origin';  
ax1.Box = 'off';  


xlim([-0.1, 2.1]);
ylim([-0.1, 0.7]);


ax1.XTick = [0, 0.5, 1, 1.5, 2];
ax1.YTick = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6];



subplot(1, 3, 2);

t1 = linspace(0, 0.999, 200);  
ddphi1 = -1 * ones(size(t1));   

t2 = linspace(1.001, 2, 200);  
ddphi2 = zeros(size(t2));       


plot(t1, ddphi1, 'r-', 'LineWidth', 3);
hold on;
plot(t2, ddphi2, 'r-', 'LineWidth', 3);
plot([0, 2], [0, 0], 'k--', 'LineWidth', 1);  
plot([1, 1], [-1.5, 0.5], 'k--', 'LineWidth', 1);  

xlabel('t = ||x||₂', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('φ''''(t)', 'FontSize', 12, 'FontWeight', 'bold');

grid on;

ax2 = gca;
ax2.XAxisLocation = 'origin';  
ax2.YAxisLocation = 'origin';  



xlim([-0.1, 2.1]);
ylim([-1.6, 0.6]);


ax2.XTick = [0, 0.5, 1, 1.5, 2];
ax2.YTick = [-1.5, -1, -0.5, 0, 0.5];




subplot(1, 3, 3);

[x1, x2] = meshgrid(linspace(-2, 2, 100), linspace(-2, 2, 100));
phi_vals = zeros(size(x1));


for i = 1:size(x1, 1)
    for j = 1:size(x1, 2)
        x = [x1(i, j); x2(i, j)];
        phi_vals(i, j) = phi(x);
    end
end


surf(x1, x2, phi_vals, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
colormap('parula');
xlabel('x_1', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('x_2', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('\phi(x)', 'FontSize', 12, 'FontWeight', 'bold');

grid on;
view(45, 30);
shading interp;

hold on;

