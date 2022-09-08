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
set(groot,'defaultAxesTickLabelInterpreter','latex');  

%% Read CSVs and plot RAW data

%%% Select folder containing CSVs
directory = 'data/HEMS_18/POSITIVOS';
% directory = 'data/HEMS_18/NEGATIVOS';
% directory = 'data/HEMS_14/POSITIVA';

os        = 10;
struct    = readCSV(directory, os);      % NOTE: important to check the 
                                         %       raw plot to adjust the
                                         %       offset.

plot_raw  = false;

%%% Plot RAW

if plot_raw
    figure(1)
    for idx = 1:numel(struct)
        plot(struct(idx).time, struct(idx).data)
        hold on
    end
    
    title('raw data')
    xlabel('rel time (s)')
    ylabel('current (A)')
end

%% Filtering

cortemax = numel(struct(1).data);

tau      = [];
Ies      = [];

for i = 1:numel(struct)
    %%% Compute sampling frequency
    %dt   = struct(i).time(2:end) - struct(i).time(1:(end-1));
    %freq = dt.^(-1);
    %freq = mean(freq);
    freq     = 1e3;

    %%% Data acquisition
    signal = struct(i).data;

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

    for j = 1:((size(signalFilt, 1)-210))
        if abs(signalFilt(j) - signalFilt(j + 210)) >0.1
            corte = j;
            break
        end
    end


    struct(i).filtered = signalFilt(corte:end);
    struct(i).data     = signal(corte:end);


    if size(signalFilt(corte:end), 1) < cortemax
        cortemax = size(signalFilt(corte:end), 1);
    end
end

for i = 1:numel(struct)

    struct(i).data     = struct(i).data(1:cortemax);
    struct(i).filtered = struct(i).filtered(1:cortemax);
    struct(i).time_vector     = 0:1/freq:1/freq*numel(struct(i).data);

    currentMat(:, i) = struct(i).filtered;

    plot(struct(i).time_vector(1:numel(struct(i).data)), struct(i).data, 'LineWidth', 1.5, 'Color', 'k')
    hold on
    plot(struct(i).time_vector(1:numel(struct(i).filtered)), struct(i).filtered, 'LineWidth', 1.5, 'Color', "#AA4E2F")
    hold on  
    
    for j = 2:size(struct(i).filtered, 1)
        
        if max(struct(i).filtered) < 4
            step = 0.5;
        else
            step = 0.45;
        end

        if abs(struct(i).filtered(1) - struct(i).filtered(j)) > step
            break
        end
    end

    scatter(struct(i).time_vector(j), struct(i).filtered(j), 'red', 'filled')

    tau(i) = (struct(i).time_vector(j) - 0.2)/4;
    Ies(i) = mean([struct(i).filtered(1), struct(i).filtered(end)].');
end

% xlim([0, 7000])
xlabel('time (s)', 'Interpreter', 'latex')
ylabel('current (A)', 'Interpreter', 'latex')
title(directory, 'interpreter', 'latex')

%% Test - try to get L by dI/dt

% i = 1;
% 
% freq = 1e4;
% n    = 1;
%     
% [z, p, k]    = besself(n, 100);         
% [num,  den]  = zp2tf(z,p,k);            
% [numd, dend] = bilinear(num, den, freq);  
% 
% signalFilt   = filtfilt(numd, dend, struct(i).filtered);
% 
% figure(1)
% clf()
% plot(struct(i).data, 'LineWidth', 1.5, 'Color', 'k')
% hold on
% plot(struct(i).filtered, 'LineWidth', 1.5, 'Color', "#AA4E2F")
% hold on
% plot(signalFilt, 'LineWidth', 1.5, 'Color', "r")
% 
% 
% dt = mean(struct(i).time(2:end) - struct(i).time(1:(end-1)));
% time = 0:dt:(dt*(size(currentMat, 1) - 1));
% 
% didt_original   = FDM(struct(i).data, time);
% didt_filter     = FDM(struct(i).filtered, time);
% didt_filtfilter = FDM(signalFilt, time);
% 
% 
% freq = 1e3;
% n    = 1;
%     
% [z, p, k]    = besself(n, 100);         
% [num,  den]  = zp2tf(z,p,k);            
% [numd, dend] = bilinear(num, den, freq);  
% 
% derivativeFilt   = filtfilt(numd, dend, didt_filter);
% 
% figure(2)
% subplot(3, 2, 1)
% plot(time(2:(end-1)), didt_original)
% subplot(3, 2, 3)
% plot(time(2:(end-1)), didt_filter)
% ylim([0 60])
% subplot(3, 2, 5)
% plot(time(2:(end-1)), didt_filtfilter)
% ylim([0 60])
% subplot(3, 2, 4)
% plot(time(2:(end-1)), derivativeFilt)
% ylim([0 60])

%% L by tau

R_HEMS = 0.314;     % [Ohm]
R_EMS  = 0.227;     % [Ohm]

[I_estimation, P1] = sort(Ies);
[L_estimation, P2] = rmoutliers(R_HEMS * tau(P1));

L_plot = smooth(L_estimation);


%%% Theoretical model
I_map = 0:0.5:35;
L_th  = HEMSmodel(I_map) .*1e3;

plot_th = true;


figure(2)
plot(I_estimation(~ P2), L_plot * 1e3, 'LineWidth', 1.5, 'Color', 'k')
hold on
plot(I_estimation(~ P2), L_estimation * 1e3, 'LineStyle', '--', 'LineWidth', 1.5, 'Color', 'r')

if plot_th
    hold on
    plot(I_map, L_th, 'LineStyle', ':', 'LineWidth', 1.5, 'Color', '#86C5D8')
    legend('inductance testing', 'inductance testing (smooth)', 'theoretical model', ...
        'interpreter', 'latex')
else
    legend('inductance testing', 'inductance testing (smooth)', 'interpreter', 'latex')
end

xlabel('current (A)', 'Interpreter','latex')
ylabel('inductance (mH)', 'Interpreter','latex')

grid on

title(directory, 'interpreter', 'none')












