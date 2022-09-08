%%% Main plotting area
colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

for idx = 1:nLines
        plot(x, f(:,idx), 'Color',colors(idx), 'LineWidth', 1.5)
        hold on
end

hold off
grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel(x_label, 'Interpreter','latex')
ylabel(y_label, 'Interpreter','latex')

legend(leyenda, 'Interpreter','latex', 'Location', 'best')

print(fig, nombre_archivo,'-dpdf','-r0')