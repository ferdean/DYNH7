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

% load sensors.mat
load CeludaCarga.mat

%% First plot
% colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];
% 
% set(groot,'defaultAxesTickLabelInterpreter','latex');  
% 
% fig = figure(1);
% 
% set(fig, 'Units', 'centimeters')
% pos = get(fig,'Position');
% set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% 
% 
% plot(sensors.sensor_10.parsed41mm(:,1),sensors.sensor_10.parsed41mm(:,2), 'LineWidth', 1.5, 'Color', colors(1))
% hold on
% plot(sensors.sensor_10.parsed45mm(:,1), sensors.sensor_10.parsed45mm(:,2), 'LineWidth', 1.5, 'Color', colors(2))
% hold on
% plot(sensors.sensor_10.parsed50mm(:,1), sensors.sensor_10.parsed50mm(:,2), 'LineWidth', 1.5, 'Color', colors(3))
% hold on
% plot(sensors.sensor_10.parsed55mm(:,1), sensors.sensor_10.parsed55mm(:,2), 'LineWidth', 1.5, 'Color', colors(4))
% hold on
% plot(sensors.sensor_10.parsed59mm(:,1), sensors.sensor_10.parsed59mm(:,2), 'LineWidth', 1.5, 'Color', colors(5))
% 
% hold off
% grid on
% 
% ax = gca;
% ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];
% 
% xlabel('timestamp', 'Interpreter','latex')
% ylabel('raw', 'Interpreter','latex')

%% First plot
colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])


plot(CelulaCarga.time, CelulaCarga.data, 'LineWidth', 1.5, 'Color', colors(1))

ylim([- 1e6, 0])

grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel('timestamp', 'Interpreter','latex')
ylabel('raw', 'Interpreter','latex')

%% Freq check
% Remove raw offset and some deffs
% raw    = sensors.sensor_10.parsed50mm(:,2);
% t      = sensors.sensor_10.parsed50mm(:,1);

raw      = CelulaCarga.data;
t        = CelulaCarga.time;

signal = raw - mean(raw); 

nDataPoints = length(t);
Tmax        = max(t);
freq        = 1/(Tmax/nDataPoints);


% FFT
signal_hat      = fft(raw);

PSD_alias    = abs(signal_hat./nDataPoints);
PSD          = PSD_alias(1:nDataPoints/2+1);
PSD(2:end-1) = 2*PSD(2:end-1);

freq_vector  = freq*(0:(nDataPoints/2))/nDataPoints;

fig_3 = figure(3);

set(fig_3, 'Units', 'centimeters')
pos = get(fig_3,'Position');
set(fig_3,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

semilogy(freq_vector, PSD, 'LineWidth', 1.5, 'Color', colors(3)) 

grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel('freq (Hz)', 'Interpreter','latex')
ylabel('PSD(f)', 'Interpreter','latex')


fig_2 = figure(2);

set(fig_2, 'Units', 'centimeters')
pos = get(fig_2,'Position');
set(fig_2,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

plot(t(20:(end-20)), raw(20:(end-20)), 'LineWidth', 1.5, 'Color', colors(1))


hold off
grid on

ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel('timestamp', 'Interpreter','latex')
ylabel('raw', 'Interpreter','latex')





