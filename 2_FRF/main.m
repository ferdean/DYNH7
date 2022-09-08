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

cd C:\FERRAN\2_Hyperloop_2022\1_dynamics_H7\2_FRF

addpath('lib')
addpath('data')

addpath('../0_Modelo/lib/')
addpath('../0_Modelo/constants/')

global pod;
constants_H7()

r_HEMS = load('data\resultados_HEMS.mat');
r_EMS  = load('data\resultados_EMS.mat');

%% Data manipulation (esto no va a ser nada elegante)
% run data_manipulation.m

%% K estimation

% cftool   %[linear regression with curve fitting tool]

% All stiffnesses in [N/m]

kHEMS    = [10280; 12120; 14760; 18210; 22360; 24690; 24540; 25030; 25560];
kHEMS_0  = 19728;

kEMS     = [38250; 28900; 13390; 3350; 0; 3350; 13390; 28900; 38250];
kEMS_0   = 18642;   

stoch    = [0.9089; 1.2589; 0.9022; 1.3308; 0.9687; 0.8729; 0.9069; 1.1350];

kHEMS_stoc = kHEMS_0 * stoch(1:6);
kEMS_stoc  = kEMS_0  * stoch(5:8);


%% System matrices and modal analysis
[K, M] = getMatrices(kHEMS_stoc, kEMS_stoc, pod);

% [K, M] = getMatrices(kL, kEMS_0 * ones(4,1), pod);

[wnHZ, phi] = modal(K, M);


%% FRF

% Recall: u = [z, y, rotx, roty, rotz]
% Then, if you want to have z displacement as an output/input, the vector
% should be [1,0,0,0,0]

output = [1, 0, 1, 1, 0]; 
input  = [1, 0, 0, 0, 0];

[wHz, uDOF] = FRF(K,M,phi,input,output);
% [wHz, uDOF] = FRF(K,M,phi,ones(5,1),ones(5,1));


%% Results

totalFRF = sum(uDOF);

set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure(1)
subplot(2,1,1)
semilogy(wHz,abs(totalFRF),'Color','k','LineWidth',1.5)
xlabel('Frequency [Hz]','Interpreter','latex')
ylabel('H(f)','Interpreter','latex')
grid on

subplot(2,1,2)
plot(wHz,angle(totalFRF),'Color','k','LineWidth',1.5)
xlabel('Frequency [Hz]','Interpreter','latex')
ylabel('$\alpha$(f)','Interpreter','latex')
ylim([-0.2, pi+0.2])
grid on






















