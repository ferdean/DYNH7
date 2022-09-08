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

cd C:\FERRAN\1_Hyper\2_Hyperloop_2022\1_dynamics_H7\3_Estudio_Inductancia
addpath('plots')
addpath('lib')

load("HEMS.mat")
load("EMS.mat")

%% HEMS Discretization 

HEMS.L = zeros((length(HEMS.current)-2), length(HEMS.airgap));        % Inductance [H]

for AG_i = 1:length(HEMS.airgap)
    HEMS.L(:, AG_i) = FDM(HEMS.flux(AG_i, :), HEMS.current);  
end

[AG_reduced_map, I_reduced_map] = meshgrid(HEMS.airgap, HEMS.current(2:(end-1)));

% plotL(AG_reduced_map(1:(end-1),:), I_reduced_map(1:(end-1),:), HEMS.L(1:(end-1),:))

%% EMS Discretization 

EMS.L = zeros((length(EMS.current)-2), length(EMS.airgap));        % Inductance [H]

for AG_i = 1:length(EMS.airgap)
    EMS.L(:, AG_i) = FDM(EMS.flux(AG_i, :), EMS.current);  
end

[AG_reduced_map, I_reduced_map] = meshgrid(EMS.airgap, EMS.current(2:(end-1)));

plotL(AG_reduced_map(1:(end-1),:), I_reduced_map(1:(end-1),:), EMS.L(1:(end-1),:))



%% Data collection - Lookup table

r.inductance              = L;
save("data.mat", "r")

%% Data collection - Regression model 

points    = zeros(numel(r.inductance),3);
current_L = current(2:(end-1));
it        = 1;

for i = 1:size(r.air_gap,2)
    for j = 1:size(current_L,2)
        points(it,:) = [r.air_gap(i), current_L(j), r.inductance(j,i)];
        it = it+1;
    end
end

x = points(1:2:end,1);
y = points(1:2:end,2);
z = points(1:2:end,3);

%%% 3D curve fitting tool
cftool 

%% Sigmoid/tanh model:

% f(x,y) = a * tanh(b *y - c)+ d*x + e
% Coefficients (with 95% confidence bounds):
%        a =   -0.008752  (-0.008818, -0.008685)
%        b =      0.1609  (0.1551, 0.1668)
%        c =       1.389  (1.336, 1.442)
%        d =   6.277e-07  (-1.387e-05, 1.512e-05)
%        e =     0.01042  (0.01017, 0.01068)

plotLmodel(AG_reduced_map, I_reduced_map, points)


%% Step model:

Lstep = zeros(size(Lmodel));

for i = 1:20
    Lstep(i,:) = 0.019 * ones(1,size(Lmodel,2));
end
for i = 21:33
    Lstep(i,:) = 0.0018 * ones(1,size(Lmodel,2));
end

%% Error computation

err_sigmoid = quadError(Lmodel(2:(end-1),:), r.inductance);
err_step    = quadError(Lstep(2:(end-1),:),  r.inductance);

%% Plot max difference

plotModels(r, Lmodel, Lstep)














