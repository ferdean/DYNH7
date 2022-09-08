%% Plot #1

% Data acquisition
position = out.position;
velocity = out.velocity;

force    = out.F_LIM;
moment   = out.MM;

% Figure initialization
figure(1)

% Main plot code

subplot(2,1,1)

plot(position, 'Color', 'k', 'LineWidth', 1.5)
hold on
plot([0,10], [14, 14], '--r')

title('\textbf{Constant velocity case}', 'Interpreter','latex')
xlabel('')
ylabel('position (m)', 'Interpreter','latex')

% Text
xpos        = 6.5;
ypos        = 16;
text_string = sprintf('\\textit{start-of-braking} distance');
text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'r');


subplot(2,1,2)

yyaxis left
plot(force, 'LineWidth', 1.5, 'Color', 'k')
ylabel('force (N)', 'Interpreter','latex')
ylim([min(force)-50 max(force)+50])

yyaxis right
plot(moment, 'LineStyle', '--', 'LineWidth', 1.5, 'Color', 'r')
ylim([min(moment)-50*pod.geometry.z_LIM max(moment)+50*pod.geometry.z_LIM])
ylabel('moment (Nm)', 'Interpreter','latex')

title('')
xlabel('time (s)', 'Interpreter','latex')

ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';

%% Plot #2

% Data extraction

load('.\F_LEV_airgap.mat')
load('.\F_LEV_current.mat')
load('.\F_LEV_airgap_HF.mat')
load('.\F_LEV_current_HF.mat')

current_map_HF      = -40:2.5:40;
airgap_map_HF       = 11:0.25:23;

current_map         = -40:2:40;
airgap_map          = 10:1:25;

air_gaps_discrete   = [11,15,18,20,23];
currents_discrete   = [-40,-20,0,20,40];


colors = {'#fdbb84','#fc8d59','#ef6548','#d7301f','#990000'};

figure(2)
set(gca,'box','on') 
grid on
hold on
for i = 1:(size(force_CUR,2))
    scatter(airgap_map, force_CUR(:,i), 'filled',...
        'MarkerFaceColor', string(colors(i)),...
        'MarkerFaceAlpha', 0.8)    
end

for i = 1:(size(HF_force_CUR, 1))
    scatter(airgap_map_HF, HF_force_CUR(i,:),...
        'MarkerEdgeColor', 'k',...
        'Marker','x',...
        'MarkerEdgeAlpha', 0.6)    
end

xlabel('airgap (mm)','Interpreter','latex')
ylabel('force (N)','Interpreter','latex')
title(' \textbf{Constant current validation}','Interpreter','latex')

xlim([11 23])

legend('-40 A', '-20 A', '0 A', '20 A', '40 A', 'High fidelity data', ...
    'Interpreter', 'latex',...
    'location','best')


%% Plot #3. Traction force behaviour (signs)

force       = out.force.Data;
position    = out.position.Data;
velocity    = out.velocity.Data;

figure(3)

subplot(2,1,1)
plot(position, velocity, 'k', 'LineWidth', 1.5)
hold on
plot([14, 14], [min(velocity), max(velocity) + 3], '--r', 'LineWidth', 1.2)

ylim([min(velocity), max(velocity) + 3])
xlim([0,max(position) + 5])

ylabel('velocity (m/s)', 'Interpreter','latex')
title('\textbf{Toy test of LIM behaviour (sign)}', 'Interpreter','latex')
% grid on


subplot(2,1,2)
plot(position, force, 'k', 'LineWidth', 1.5)
hold on
plot([14, 14], [min(force), max(force)], '--r', 'LineWidth', 1.2)
hold on
plot([0,max(position) + 5], [0,0], 'k')

xlim([0,max(position) + 5])
ylabel('LIM force (N)', 'Interpreter','latex')
xlabel('position (m)', 'Interpreter','latex')
% grid on

%% Plot #4. Levitation force dynamic behaviour

Fx = out.Fx;
Fz = out.Fz;
ML = out.ML;
MM = out.MM;


fig = figure(4);
fig.Renderer='Painters';

yyaxis left

plot(Fx, 'k', 'LineWidth', 1.5)
hold on
plot(Fz, 'Color','k', 'LineStyle', '--', 'LineWidth', 1.5)

ylabel('force (N)', 'Interpreter','latex')
ylim([-1500, 500])


yyaxis right
plot(MM, 'r', 'LineWidth', 1.5)
plot(ML, 'Color','r', 'LineStyle', '--', 'LineWidth', 1.5)

ylim([-15, 40])
xlabel('simulation time (s)', 'Interpreter','latex')
ylabel('moment (Nm)', 'Interpreter','latex')

title('\textbf{Dynamics (case 5) for ag = 18 mm, I = 0 A, drag for 5m/s}', 'Interpreter','latex')

ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';

legend('Fx','Fz','MM','ML')



%% Plot #5. Guidance force dynamic behaviour

Fy = out.Fy;
ML = out.ML;
MN = out.MN;
current = out.current;

fig = figure(5);
fig.Renderer='Painters';

subplot(2,1,1)

yyaxis left
% hold on
plot(Fy, 'k', 'LineWidth', 1.5)
ylabel('force (N)', 'Interpreter','latex')
ylim([-10, 10])

yyaxis right
plot(MN, 'r', 'LineWidth', 1.5)
hold on
plot(ML, 'Color','r', 'LineStyle', '--', 'LineWidth', 1.5)

ylim([-4, 4])
ylabel('moment (Nm)', 'Interpreter','latex')
xlabel('')

title('\textbf{Dynamics (case 2) for ag = 18 mm}', 'Interpreter','latex')

ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';

legend('Fy','MN','ML')


subplot(2,1,2)
plot(current, 'k', 'LineWidth', 1.5)
ylim([0, 12])
ylabel('intensity in unit \#1 (A)', 'Interpreter','latex')
xlabel('simulation time (s)', 'Interpreter','latex')
title('')

%% Plot #6. Braking block validation

position = reshape(out.position.Data, [1, length(out.position.Data)]);
velocity = reshape(out.velocity.Data, [1, length(out.position.Data)]);
force    = reshape(out.force.Data, [1, length(out.position.Data)]);


set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure(6)

subplot(2,1,1)
plot(position,velocity, 'k', 'LineWidth', 1.5)
hold on
ymax = max(velocity) + 2;
plot([14,14], [0, ymax],'--r')
hold on
b = fill([14, 14, 20, 20], [ymax, 0, 0, ymax], 'r');
b.FaceAlpha = 0.3;
% b.EdgeApha = 0;

ylim([0, ymax])
xlim([0, 20])
ylabel('velocity (m/s)', 'Interpreter','latex')


xpos = 15;
ypos = 9;

text_string = sprintf('\\textbf{relevant area}');
plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'r');


subplot(2,1,2)

plot(position, force, 'k', 'LineWidth', 1.5)
hold on

ymax = max(force) + 200;
ymin = min(force) - 200;

b = fill([14, 14, 20, 20], [ymax, ymin, ymin, ymax], 'r');
b.FaceAlpha = 0.3;
hold on

plot([0, 20], [- 1326, - 1326], '--k')

xpos = 2;
ypos = -1100;

text_string = sprintf('F$$_{Analytical}$$ = -1326 N ');
plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'k');


ylim([ymin, ymax])
xlim([0, 20])

ylabel('force (N)', 'Interpreter','latex')
xlabel('position (m)', 'Interpreter','latex')

%% Plot #7. Brakes dynamic behaviour (failure)
% 
position = [];
velocity = position;
force_x  = position;
force_y  = position;
moments  = [];
iteration = 0;

dtMax    = 1e-3;

for i = 1:5

    switch i
        case 1
        pod.brakes.working_actuators    = [0 1 1 1];
        
        case 2 
        pod.brakes.working_actuators    = [0 0 1 1];
        
        case 3 
        pod.brakes.working_actuators    = [0 1 0 1];
        
        case 4
        pod.brakes.working_actuators    = [1 0 0 1];

        case 5
        pod.brakes.working_actuators    = [1 0 0 0];
    end

    results = sim("tests_and_trash.slx");
    
    position(i,:)  = reshape(results.position.Data, [1, length(results.position.Data)]);
    velocity(i,:)  = reshape(results.velocity.Data, [1, length(results.velocity.Data)]);
    force_x(i,:)   = reshape(results.force_x.Data,  [1, length(results.force_x.Data)]);
    force_y(i,:)   = reshape(results.force_y.Data,  [1, length(results.force_y.Data)]);
    moments(:,:,i) = results.moments.Data;

    iteration = iteration + 1;
    fprintf(['Iteration: ', num2str(iteration), '\n'])
end
% 
% figure(7)
% 
% colors = {'#fdbb84','#fc8d59','#ef6548','#d7301f','#990000'};
% 
% 
% for i = 1:5
%     if i == 4
%     plot(position(i,:), velocity(i,:), "Color", string(colors(i)),...
%         'LineWidth', 1.5, 'LineStyle', '--')
% 
%     else
%     plot(position(i,:), velocity(i,:), "Color", string(colors(i)),...
%         'LineWidth', 1.5)
% 
%     end
% 
%     hold on
% end
% 
% plot([20 20], [0 10], '--r', 'LineWidth', 1.75)
% 
% xpos = 21; 
% ypos = 7.8;
% text_string = sprintf('end of tube');
% plotText = text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'r');
% set(plotText,'Rotation',90)
% 
% 
% ylim([0 10])
% xlim([0 30])
% 
% xlabel('position (m)', 'Interpreter','latex')
% ylabel('velocity (m/s)', 'Interpreter','latex')
% 
% title('\textbf{Failure modes validation}','Interpreter','latex')
% 
% legend('Brake \#1 failure','Brakes \#1 and \#2 failure',...
%        'Brakes \#1 and \#3 failure', 'Brakes \#2 and \#3 failure',...
%        'Only brake \#1 correct', ...
%        'Interpreter', 'latex', 'location', 'southwest');
% 
% 
% 
% grid on


fig = figure(8);
fig.Renderer='Painters';


subplot(2,3,1)
plot(position(1,:), moments(:,1,1)', '.-r', ...
     position(1,:), moments(:,2,1)', '--k', ...
     position(1,:), moments(:,3,1)', '-b', ...
    'LineWidth', 1.5)
title('\textbf{Brake \#1 failure}', 'Interpreter','latex')
ylim([-600, 600])

subplot(2,3,2)
plot(position(2,:), moments(:,1,2)', '.-r', ...
     position(2,:), moments(:,2,2)', '--k', ...
     position(2,:), moments(:,3,2)', '-b', ...
    'LineWidth', 1.5)
title('\textbf{Brakes \#1 and \#2 failure}', 'Interpreter','latex')
ylim([-600, 600])

subplot(2,3,4)
plot(position(3,:), moments(:,1,3)', '.-r', ...
     position(3,:), moments(:,2,3)', '--k', ...
     position(3,:), moments(:,3,3)', '-b', ...
    'LineWidth', 1.5)
title('\textbf{Brakes \#1 and \#3 failure}', 'Interpreter','latex')
ylim([-600, 600])

subplot(2,3,5)
plot(position(5,:), moments(:,1,5)', '.-r', ...
     position(5,:), moments(:,2,5)', '--k', ...
     position(5,:), moments(:,3,5)', '-b', ...
    'LineWidth', 1.5)
title('\textbf{Only brake \#1 correct}', 'Interpreter','latex')
ylim([-600, 600])

subplot(2,3,[3 6])
plot(position(1,:), nan, '.-r', ...
     position(2,:), nan, '--k', ...
     position(3,:), nan, '-b')

axis off
legend('ML', 'MM', 'MN', ...
                     'Interpreter', 'latex', 'location', 'northwest');
% 
% lineh = findobj(objh,'type','line');
% 
% set(lineh(1),'LineStyle', '-.')
% set(lineh(2),'LineStyle', '--')
% set(lineh(3),'LineStyle', '-')
% 
% set(lineh(1),'Color', 'red')
% set(lineh(2),'Color', 'black')
% set(lineh(3),'Color', 'blue')
% 
% set(lineh(1),'LineWidth', 1.5)
% set(lineh(2),'LineWidth', 1.5)
% set(lineh(3),'LineWidth', 1.5)
% 
% set(lineh(1),'Marker', 'none')
% set(lineh(2),'Marker', 'none')
% set(lineh(3),'Marker', 'none')



%% Plot #8. Brakes. Timestep
figure(9)
set(groot,'defaultAxesTickLabelInterpreter','latex');  


subplot(1,2,1)
yyaxis left
plot(out.tout, reshape(out.position.Data,1,[]), 'k', 'LineWidth', 1.5)
ylabel('position (m)', 'Interpreter','latex')

yyaxis right
plot(out.tout, reshape(out.force_x.Data, 1, []), 'r', 'LineWidth', 1.5)


xlabel('time (s)', 'Interpreter','latex')
ylabel('force (N)', 'Interpreter','latex')

xlim([0 6])
ylim([-1200,100])


ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';

% daspect([1 1 1])

title('\textbf{t$$_{step}$$ =} $$1\cdot 10^{-1} s$$', 'Interpreter','latex')

subplot(1,2,2)
yyaxis left
plot(results.tout, reshape(results.position.Data,1,[]), 'k', 'LineWidth', 1.5)
ylabel('position (m)', 'Interpreter','latex')

yyaxis right
plot(results.tout, reshape(results.force_x.Data, 1, []), 'r', 'LineWidth', 1.5)


xlabel('time (s)', 'Interpreter','latex')
ylabel('force (N)', 'Interpreter','latex')
title('\textbf{t$$_{step}$$ =} $$1\cdot 10^{-5} s$$', 'Interpreter','latex')

xlim([0 6])
ylim([-1200,100])

ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';


% daspect([1 1 1])

%% Plot #9. Wheels

time = out.tout;
z    = out.z.Data;
F_x  = out.F_x.Data;
MM   = out.MM.Data;

figure(10)

subplot(2,1,1)
yyaxis left
plot(time, F_x, 'Color', 'black', 'LineWidth', 1.5)
ylabel('force (N)', 'Interpreter', 'latex')
xlabel('time (s)', 'Interpreter','latex')
ylim([-5 50])

yyaxis right
plot(time, MM, 'Color', 'red', 'LineWidth', 1.5, 'LineStyle', '--')
ylabel('moment (Nm)', 'Interpreter', 'latex')
ylim([-20 15])  

ax                  = gca;
ax.YAxis(1).Color   = 'k';
ax.YAxis(2).Color   = 'r';

subplot(2,1,2)
plot(time,z,'Color', 'black', 'LineWidth', 1.5)
hold on
plot([0 3], [11 11], '--r')
hold on
plot([0 3], [0 0], '--r')

xpos = 0.25;
ypos = 10;

text_string = sprintf('upper limit');

text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'r');

xpos = 2.5;
ypos = 1;

text_string = sprintf('ground');

text(xpos, ypos, text_string, 'Interpreter', 'latex', 'Color', 'r');


ylabel('position Z (mm)', 'Interpreter','latex')
xlabel('time (s)', 'Interpreter','latex')

ylim([-1 12])

















