x = [0.000 0.789 1.579 2.368 3.157 3.947 4.736 5.525 6.315 7.104 7.893 9.472 11.051 12.629 14.208 15.787]; %velocity [mps]
z = [234.478 226.478 220.095 213.302 205.904 197.784 188.810 178.848 167.819 155.658 142.330 109.947 77.650 40.028 3.679 -48.136]; %Propulsion Force [N]

x_grid = linspace(0,16,100);
fitting = 232.8 - 6.354000.*x_grid - 0.604400.*x_grid.^2 - 0.007235.*x_grid.^3;

% f_simulink = force;

 colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];
 
set(groot,'defaultAxesTickLabelInterpreter','latex');  
    
fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])


plot(x_grid, fitting,'--k','LineWidth', 1.5)
hold on
% scatter(x, f_simulink,'filled','black','MarkerFaceAlpha',0.8,'Marker','^')
hold on
scatter(x,z, 'MarkerEdgeColor', colors(1), 'MarkerFaceColor', colors(1))
plot([x(1), x(end)+1],[0, 0], 'k')

xlim([0, 16])

grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

% title('\textbf{Propulsion force data fitting}','Interpreter','latex')
xlabel('Velocity [m/s]','Interpreter','latex')
ylabel('Propulsion force [N]','Interpreter','latex')

legend('  Polynomial fitting ($$R^2 = 0.9997$$)',...
    '  Simulation data (high fidelity)','Interpreter','latex')


% Text
xpos = 1;
ypos = -70;

text_string = sprintf('$$F(v) = 232.8 - 6.354v - 0.6044v^2 - 0.007235v^3$$');
fig1_comps.plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'k');

set(gcf, 'Renderer', 'painters')
print(gcf, '-dpdf', 'LIMpropulsion.pdf')
