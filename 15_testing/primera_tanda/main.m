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


%% Data adquisition

table.Properties.VariableNames{1} = 'type';
table.Properties.VariableNames{2} = 'value';

keys = table.type;
keys = unique(keys);

disp(keys)

coilCurrent = table.value(table.type == " GeneralData0.CoilCurrent");
batVoltage  = table.value(table.type == " GeneralData0.BatteryVoltage");
duty        = table.value(table.type == " ConfigDutyCycle0.DutyCycle");

nData   = length(coilCurrent);

negativo.coilCurrent.original = coilCurrent;
negativo.batVoltage.original  = batVoltage;
negativo.duty                 = duty;
negativo.freq                 = 10e3;
negativo.time                 = linspace(0, nData/negativo.freq, nData);

save('negativo.mat', 'negativo')

%% First plot
% time    = negativo.time;
% current = negativo.coilCurrent.original;
% voltage = negativo.batVoltage.original;
% time    = time_original;
% current = coil_original;
% voltage =  bat_original;

nData   = length(current);

%%% Plotin

colors = ["k", "#AA4E2F", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

subplot(2, 1, 1)
plot(time, current * 1e-2, 'LineWidth', 1.5, 'Color', colors(1))
grid on
ylabel('coil current (A)', 'Interpreter', 'latex')

% ylim([-5 50])
% xlim([0 27])

subplot(2, 1, 2)
plot(time, voltage * 1e-3 , 'LineWidth', 1.5, 'Color', colors(2))
grid on
ylabel('bat voltage (V)', 'Interpreter', 'latex')
xlabel('time (s)', 'Interpreter','latex')

% ylim([-5 50])
% xlim([0 27])
%% PSD

% signal = negativo.batVoltage.original;
% freq   = negativo.freq;
% nData  = length(signal);
% time =  negativo.time;
signal = current;
%%% FFT
signal_hat      = fft(signal, nData);

PSD = abs(signal_hat./nData);
L   = 1:ceil(nData/2);

freq_vector  = freq*(0:(nData/2))/nData;


%%% FFT filtering - Bessel filter 

n = 1;

[z, p, k]    = besself(n, 100);         
[num,  den]  = zp2tf(z,p,k);            
[numd, dend] = bilinear(num, den, freq);  

signalFilt   = filtfilt(numd, dend, signal);
signalFilt   = filtfilt(numd, dend, signalFilt);
signalFilt   = filtfilt(numd, dend, signalFilt);

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

plot(time, signal * 1e-2, 'LineWidth', 1.5, 'Color', colors(1))
hold on
plot(time, signalFilt * 1e-2, 'LineWidth', 1.5, 'Color', colors(2))

grid on
ylabel('coil current (A)', 'Interpreter', 'latex')

% ylim([45 48])
% xlim([14 19])



%% Plotting
fig = figure(3);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

semilogy(freq_vector, PSD(L), 'LineWidth', 1.5, 'Color', colors(3)) 
hold on
plot([0, 2500], [100, 100], 'LineStyle', '--', 'LineWidth', 1.5, 'Color', 'r')
hold on 
semilogy(freq_vector, PSDclean(L), 'LineWidth', 1.5, 'Color', colors(5)) 

grid on


ax = gca;
ax.PlotBoxAspectRatio = [(1 + sqrt(5))/2, 1, 1];

xlabel('freq (Hz)', 'Interpreter','latex')
ylabel('PSD(f)', 'Interpreter','latex')


fig_4 = figure(4);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

subplot(2, 1, 1)
plot(time, current * 1e-3, 'LineWidth', 1.5, 'Color', colors(1))
hold on
plot(time, signalFilt * 1e-3, 'LineWidth', 1.5, 'Color', colors(5))

grid on
ylabel('Current (A)', 'Interpreter', 'latex')

% subplot(2, 1, 2)
% plot(time, voltage, 'LineWidth', 1.5, 'Color', colors(2))
% grid on
% ylabel('Voltage (unk. unit)', 'Interpreter', 'latex')
% xlabel('Time (s)', 'Interpreter','latex')











































