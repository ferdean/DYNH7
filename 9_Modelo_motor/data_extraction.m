%%% Data extraction 
clc;
clear;
close all;

load('StructAcceleration.mat')


%% Airgap variation study

    
set(groot,'defaultAxesTickLabelInterpreter','latex');  

figure;
ax1 = axes;
f1 = surf(acc.airgaps, speed, reshape(acc.force_y(:,:,16),5,11).','EdgeColor','none', 'FaceAlpha', 0.8);

pbaspect([1 1 1])

xlabel('Airgap [mm]', 'Interpreter','latex')
ylabel('Velocity [m/s]', 'Interpreter','latex')
zlabel('Transversal force [N]', 'Interpreter','latex')

% ax2 = axes;
% f2 = surf(acc.voltage, acc.speed, reshape(acc.force_y(5,:,:), 11, 23),'EdgeColor','none', 'FaceAlpha', 0.8);
% pbaspect([1 1 1])
% % 
% % ax3 = axes;
% f3 = surf(acc.voltage, acc.speed, reshape(acc.force_y(3,:,:), 11, 23),'EdgeColor','none', 'FaceAlpha', 0.8);
% pbaspect([1 1 1])

% % linkaxes([ax1, ax2, ax3])
% linkaxes([ax1, ax2])
% 
% 
% pbaspect([1 1 1])
% 
% %%Hide the top axes
% ax2.Visible = 'off';
% ax2.XTick = [];
% ax2.YTick = [];
% 
% % %%Hide the top axes
% % ax3.Visible = 'off';
% % ax3.XTick = [];
% % ax3.YTick = [];
% 
% 
% %%Give each one its own colormap
% colormap(ax1,'copper')
% colormap(ax2,'bone')
% % colormap(ax3,'gray')
% 
% % legend([f1, f2, f3], {'ag = 3 mm','ag = 3.5 mm','ag = 4 mm'}, 'interpreter', 'latex', 'Location','best')
% legend([f1, f2], {'ag = 3 mm','ag = 5 mm'}, 'interpreter', 'latex', 'Location','best')

% 
% set(gcf, 'Renderer', 'painters')
% print(gcf, '-dpdf', 'test.pdf')


%% Data extraction 

voltage  = acc.voltage;
speed    = acc.speed;

xForce  = reshape(mean(acc.force_x), 11, 23);
current = reshape(mean(acc.current), 11, 23);


% Fx (voltage, speed):
% 
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y
% Coefficients (with 95% confidence bounds):
%        p00 =   1.146e-14  (-4.053, 4.053)
%        p10 =       8.158  (7.85, 8.467)
%        p01 =   2.672e-15  (-0.7631, 0.7631)
%        p20 =  -3.175e-17  (-0.006266, 0.006266)
%        p11 =      -1.202  (-1.232, -1.172)


% Current (voltage, speed):
%
%      f(x,y) = p00 + p10*x + p01*y + p11*x*y + p02*y^2
% Coefficients (with 95% confidence bounds):
%        p00 =       3.044  (2.475, 3.614)
%        p10 =        2.87  (2.85, 2.89)
%        p01 =      -2.571  (-2.803, -2.339)
%        p11 =    -0.01369  (-0.01799, -0.009392)
%        p02 =      0.3258  (0.2999, 0.3516)


%%% As Fy is a 4D function, cftool cannot be used. Instead, we define the
%%% Ndimensional function multyPolyRegress

[SPmap, AGmap ,Vmap] = meshgrid(speed, acc.airgaps, voltage);
yForce  = acc.force_y;

yForceFlatten = reshape(yForce, [], 1);
speedFlatten  = reshape(SPmap,  [], 1);
airgapFlatten = reshape(AGmap,  [], 1);
voltFlatten   = reshape(Vmap,   [], 1);

map           = [speedFlatten, airgapFlatten, voltFlatten];

reg = multiPolyRegress(map, yForceFlatten, 3);





%% 

F_test = Fy(speedFlatten, airgapFlatten, 30 * ones(1265, 1));


plot3(speedFlatten, airgapFlatten, F_test)











