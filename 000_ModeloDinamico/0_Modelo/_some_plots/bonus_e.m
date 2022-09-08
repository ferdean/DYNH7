x_1 = -1:0.01:0;
x_2 =  0:0.01:1;

set(groot,'defaultAxesTickLabelInterpreter','latex');  
% figure(1)
% 
% phi_1_1 = 1 - 3 * x_1.^2 - 2 * x_1.^3;
% phi_1_2 = 1 - 3 * x_2.^2 + 2 * x_2.^3;
% 
% phi_2_1 = - (-x_1 - 2 * x_1.^2 - x_1.^3);
% phi_2_2 = x_2 - 2 * x_2.^2 + x_2.^3;
% 
% 
% plot(x_1, phi_1_1, 'Color', 'k', 'LineWidth', 1.5)
% hold on
% plot(x_2, phi_1_2, 'Color', 'k', 'LineWidth', 1.5)
% hold on
% plot(x_1, phi_2_1, 'Color', 'r', 'LineWidth', 1.5)
% hold on
% plot(x_2, phi_2_2, 'Color', 'r', 'LineWidth', 1.5)
% 
% legend('$\varphi_1$','','$\varphi_2$','','interpreter','latex')
% grid on

a = -2;
b =  0.5;
c =  3;

x_3 = a:0.01:b;
x_4 = b:0.01:c;

figure(2)

alpha = 2;
beta  = 2;

dphi_1_1 = -6 * x_1 .* (x_1 + 1);
dphi_1_2 =  6 * x_2 .* (x_2 - 1);
dphi_2_1 = 3 * x_1.^2 + 4 * x_1 + 1;
dphi_2_2 = 3 * x_2.^2 - 4 * x_2 + 1;


plot(x_1, alpha * phi_1_1 + beta * phi_2_1, 'Color', 'k', 'LineWidth', 1.5)
hold on
plot(x_2, alpha * phi_1_2 + beta * phi_2_2, 'Color', 'k', 'LineWidth', 1.5)
grid on

plot(x_1, alpha * dphi_1_1 + beta * dphi_2_1, 'Color', 'r', 'LineWidth', 1.5)
hold on
plot(x_2, alpha * dphi_1_2 + beta * dphi_2_2, 'Color', 'r', 'LineWidth', 1.5)








function [map] = theta_1(x, b, a)
    map = x * (b - a) + b;
end

function [map] = theta_2(x, c, b)
    map = x * (c - b) + b;
end

function [map] = thetaInv_1(x, b, a)
    map = (x - a)/(b - a) - 1;
end

function [map] = thetaInv_2(x, c, b)
    map = (x - b)/(c - b);
end