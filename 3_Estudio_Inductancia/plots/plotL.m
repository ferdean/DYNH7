function plotL(AG_map, I_map, inductance)
% Creates a plot of the minductance as a funtion of airgap and intensity
% ═════════════════════════════════════════════════════════════════════════
% Created by:       Ferran de Andres 
% Last updated by:  Ferran de Andres 
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 12.01.2022
% ═════════════════════════════════════════════════════════════════════════

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure();

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
        

s = surf(AG_map, I_map, inductance);
s.EdgeColor = 'white';
s.EdgeAlpha = 0.25;

% title('\textbf{Inductance \textit{megabarrido}}','Interpreter','latex')
xlabel('Air gap [mm]','Interpreter','latex')
ylabel('Current [A]','Interpreter','latex')
zlabel('Flux [Wb]','Interpreter','latex')

colormap copper
view([120, 120, 120])
set(gcf, 'Renderer', 'painters')
print(gcf, '-dpdf', 'test.pdf')

end

