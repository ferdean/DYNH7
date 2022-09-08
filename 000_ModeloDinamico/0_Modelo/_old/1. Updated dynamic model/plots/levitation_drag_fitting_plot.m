x = [0.00 1.5 3 4.5 6 7.5 9];                       % [m/s]
z = [-0.009 4.600 7.607 8.514 8.522 8.071 7.653];   % [N]

x_grid = linspace(0,10,100);
fitting = 0.02696.*x_grid.^3- 0.598.*x_grid.^2+ 4.054.*x_grid - 0.06036;



set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure(1)

plot(x_grid,fitting,'--k','LineWidth',2)
hold on
scatter(x,z,'red','filled','MarkerFaceAlpha',0.75)

xlim([0, 9])
ylim([0, 10])


title('\textbf{Levitation drag force data fitting}','Interpreter','latex')
xlabel('Absolute velocity [m/s]','Interpreter','latex')
ylabel('Drag force [N]','Interpreter','latex')

legend('  Polynomial fitting ($$R^2 = 0.9990$$)','  Simulation data',...
    'Interpreter','latex','Location','southeast')


% Text
xpos = 1;
ypos = 2;

text_string = sprintf('$$F(v)=0.02696 x^{3}-0.598 x^{2}+4.054 x-0.06036$$');
fig1_comps.plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'k');



pbaspect([1 1 1])

grid on

