colors = ["#a0da39", "#1fa187", "#365c8d", "k", "#0d0887", "#DADAE2"];

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])



plot(yy, lambda001(1:1000), 'LineWidth', 1.5, 'Color', colors(1), 'LineStyle', '-')
hold on
plot(yy, lambda01(1:1000), 'LineWidth', 1.5, 'Color', colors(2), 'LineStyle', '--')
hold on
plot(yy, lambda1(1:1000), 'LineWidth', 1.5, 'Color', colors(3), 'LineStyle', '-.')
hold on
plot(yy, lambda10(1:1000), 'LineWidth', 1.5, 'Color', colors(4), 'LineStyle', ':')



xlabel('y-direction (-)', 'Interpreter', 'latex')
ylabel('temperature (-)', 'Interpreter','latex')



grid on

xlim([0 150])

legend('$\lambda$ = 0.01', ...
    '$\lambda$ = 0.1', ...
    '$\lambda$ = 1', ...
    '$\lambda$ = 10', ...
    'Location', 'best', 'Interpreter', 'latex')
 
% subplot(2,1,1);
% 
% plot(excentricity_map, I_front_double, 'LineWidth', 1.5, 'Color', colors(1))
% hold on 
% plot([0.01281 0.01281], [-10 1], 'LineWidth', 1.2, 'LineStyle', '-.', 'Color', 'r')
% 
% ylabel('Current (A)', 'Interpreter','latex')
% legend('\textbf{Front units}', 'Interpreter','latex')
% grid on 
% 
% 
% subplot(2,1,2); 
% plot(excentricity_map, I_rear_double, 'LineWidth', 1.5, 'Color', colors(2))
% hold on 
% plot([0.01281 0.01281], [-1 10], 'LineWidth', 1.2, 'LineStyle', '-.', 'Color', 'r')
% ylabel('Current (A)', 'Interpreter','latex')
% xlabel('COG excentricity (m)', 'Interpreter','latex')
% legend('\textbf{Rear units}', 'Interpreter','latex')
% grid on 
% 
% 
% print(fig, 'EqPointModel','-dpdf','-r0')