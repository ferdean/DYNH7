x = [     0     5    10    15    20    25 ];                       % [m/s]
z = [305.6727  333.7478  347.0536  346.6504  336.5243  321.6713];   % [N]

x_grid = linspace(0,25,100);
fitting = 307.3 + 6.009 .* x_grid - 0.2203 .* x_grid.^2;

%%% Main plotting area
colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
    
  

plot(x_grid/3.6,fitting,'LineStyle', '--', 'Color', colors(2),'LineWidth', 1.5)
hold on
scatter(x/3.6,z,'MarkerEdgeColor', colors(1),'MarkerFaceColor', colors(1))


ylim([200 400])

% title('\textbf{Levitation drag force data fitting}','Interpreter','latex')
xlabel('Velocity [m/s]','Interpreter','latex')
ylabel('Braking force [N]','Interpreter','latex')

legend('  Polynomial fitting ($$R^2 = 0.995$$)','  Simulation data',...
    'Interpreter','latex','Location','southeast')


% Text
xpos = 1;
ypos = 250;

text_string = sprintf('$$F(v)=-0.220 v^{2}+6.009 v + 307.3$$');
fig1_comps.plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'k');

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

grid on

set(gcf, 'Renderer', 'painters')
print(gcf, '-dpdf', 'LIMbrake.pdf')
