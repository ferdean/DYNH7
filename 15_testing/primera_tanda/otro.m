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
%% Script initialization and data adquisition

clear
clc
close all

load matrix.mat

time    = matrix(:, 1);
trigger = matrix(:, 2);
current = matrix(:, 3);


cuts = [157565, 221499;
        230930, 294136;
        298878, 358466;
        372196, 431706;
        520252, 589351];

names    = {'sec_1', 'sec_2', 'sec_3', 'sec_4', 'sec_5'};

freq     = 40e3;
lim_temp = 56000;
T        = (freq)^-1 * lim_temp;
rel_time = linspace(0, T, lim_temp);

for i = 1:numel(names)
    
    sections.(names{i}) = current(cuts(i, 1): cuts(i, 2));
    temporal            = sections.(names{i});

    sections.(names{i}) = temporal(1:lim_temp);



    subplot(numel(names), 1, i)
    plot(rel_time, sections.(names{i}))
    xlim([0, 1.6])
    ylim([-2, 5])

end

xlabel('time (s)', 'Interpreter','latex')

%% Filtering

set(groot,'defaultAxesTickLabelInterpreter','latex');  

fig = figure(1);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

signalFiltMat = zeros(lim_temp, numel(names));

for i = 1:numel(names)
    
    signal = sections.(names{i});

    nData  = length(signal);
    freq_vector  = freq*(0:(nData/2))/nData;

    signal_hat = fft(signal, nData);

    PSD = abs(signal_hat./nData);
    L   = 1:ceil(nData/2);
    
    %%% FFT filtering - Bessel filter 

    n = 1;
    
    [z, p, k]    = besself(n, 100);         
    [num,  den]  = zp2tf(z,p,k);            
    [numd, dend] = bilinear(num, den, freq);  
    
    signalFilt   = filtfilt(numd, dend, signal);

    signalFiltMat(:, i) = signalFilt;


    subplot(numel(names), 1, i)
    plot(rel_time, signal, 'LineWidth', 1.5, 'Color', 'k')
    hold on
    plot(rel_time, signalFilt, 'LineWidth', 1.5, 'Color', "#AA4E2F")


    xlim([0, 1.4])
    ylim([-2, 5])
    
end

xlabel('time (s)', 'Interpreter', 'latex')

print(fig, 'secciones_filtradas','-dpdf','-r0')

%% Average - signal cleaning

cleanSignal = mean(signalFiltMat, 2);

%% Finite differences derivative

didt = FDM(cleanSignal, rel_time);

fig = figure(2);

set(fig, 'Units', 'centimeters')
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

subplot(2, 1, 1)
plot(rel_time, cleanSignal, 'LineWidth', 1.5, 'Color', 'k')
grid on
ylabel('current (A)', 'Interpreter','latex')

subplot(2, 1, 2)

plot(rel_time(2:(end-1)), didt, 'LineWidth', 1.5, 'Color', '#AA4E2F')
grid on

ylabel('$\partial I / \partial t$ (A/s)', 'Interpreter','latex')
xlabel('time (s)', 'Interpreter','latex')

print(fig, 'señal_limpia','-dpdf','-r0')








































