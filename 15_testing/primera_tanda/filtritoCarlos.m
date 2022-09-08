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

%% Script body
load data\corriente.mat
load data\time_corriente.mat

corriente = corriente(~isnan(corriente));
time      = time_corriente(~isnan(corriente));

dt        = mean(time(2:end) - time(1:(end-1)));
freq      = 1/dt;

%%% Filter
n            = 1;
[z, p, k]    = besself(n, 100);         
[num,  den]  = zp2tf(z,p,k);            
[numd, dend] = bilinear(num, den, freq);  

signalFilt   = filtfilt(numd, dend, corriente);

n            = 1;
[z, p, k]    = besself(n, 100);         
[num,  den]  = zp2tf(z,p,k);            
[numd, dend] = bilinear(num, den, freq*4);  

signalFiltFilt   = filtfilt(numd, dend, corriente);

%%% Plot
fig = figure(1);

subplot(211)

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

plot(time, corriente, 'LineWidth', 1.5, 'Color', 'k')
hold on
plot(time, signalFilt, 'LineWidth', 1.5, 'Color', 'r')
hold on
plot(time, signalFiltFilt, 'LineWidth', 1.5, 'Color', 'b')

ylim([-20 50])
ylabel('corriente (A)', 'Interpreter', 'latex')

subplot(212)

plot(time, corriente, 'LineWidth', 1.5, 'Color', 'k')
hold on
plot(time, signalFilt, 'LineWidth', 1.5, 'Color', 'r')
hold on
plot(time, signalFiltFilt, 'LineWidth', 1.5, 'Color', 'b')

ylim([2 12])
xlim([54 68])
ylabel('corriente (A)', 'Interpreter', 'latex')
xlabel('time (s)', 'Interpreter', 'latex')
title('\textbf{detalle}', 'Interpreter', 'latex')

