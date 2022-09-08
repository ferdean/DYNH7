% ╔═══════════════════════════════════════════════════════════════════════╗
% ║───────────────╔╗─╔╗───────────╔╗──────────╔╗─╔╦═══╦╗──╔╗──────────────║
% ║───────────────║║─║║───────────║║──────────║║─║║╔═╗║╚╗╔╝║──────────────║
% ║───────────────║╚═╝╠╗─╔╦══╦══╦═╣║╔══╦══╦══╗║║─║║╚═╝╠╗║║╔╝──────────────║
% ║───────────────║╔═╗║║─║║╔╗║║═╣╔╣║║╔╗║╔╗║╔╗║║║─║║╔══╝║╚╝║───────────────║
% ║───────────────║║─║║╚═╝║╚╝║║═╣║║╚╣╚╝║╚╝║╚╝║║╚═╝║║───╚╗╔╝───────────────║
% ║───────────────╚╝─╚╩═╗╔╣╔═╩══╩╝╚═╩══╩══╣╔═╝╚═══╩╝────╚╝────────────────║
% ║───────────────────╔═╝║║║──────────────║║──────────────────────────────║
% ║───────────────────╚══╝╚╝──────────────╚╝──────────────────────────────║
% ╚═══════════════════════════════════════════════════════════════════════╝
%% Script initialization
clear
clc
close all

addpath ./data

load ensayos.mat 
load validacion.mat

%% Data cleaning (Javi's code)
data = plotear(ensayos, 0);

%% Regression model

HEMS = regressionModel(data.current, data.airgap, data.force, ...
                       'plotflag', true);

% HEMS(current, airgap) is now a differentiable continuous function that
% computes the force as a function of current and aircap

%% 2D-slice plot (JL)

airgap = 13; % CHANGE THIS

%%% Data management - test
fun = @(x) ensayos(1).s(x).airgap(1) == airgap;
tf  = arrayfun(fun, 1:numel(ensayos(1).s));
idx = find(tf);

currentTest = ensayos(1).s(idx).current;
forceTest   = ensayos(1).s(idx).force;

%%% Data management - model
currentMap = -40:40;
agMap      = airgap * ones(size(currentMap));

modelForce = HEMS(currentMap, agMap);

%%% Plot
set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(2);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

plot(currentTest, forceTest, 'Color', 'k', 'LineWidth', 1.5, 'LineStyle', '-');
hold on
plot(currentMap, modelForce, 'Color', '#C0C0C0', 'LineWidth', 1.5, 'LineStyle', '-.');

hold off
grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel('current (A)', 'Interpreter','latex')
ylabel('force (N)',  'Interpreter','latex')

legend('Test', 'Model', 'Interpreter','latex', 'Location', 'best')

print(fig, sprintf(['airgap_',num2str(airgap)]),'-dpdf','-r0')

