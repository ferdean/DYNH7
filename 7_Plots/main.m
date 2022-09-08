% This script plots some given data with the corporative layout for the
% Hyperloop UPV's Final Demonstration Documentation. It takes no input nor
% generates outputs explicitly, but guides the user through the process.
% 
% If there's any issue with the implementation or you need special
% characteristics in your plot (like other LineStyles or text), contact
% Ferran de Andrés. 
% ═════════════════════════════════════════════════════════════════════════
% Created by:       Hyperloop UPV Team (Dynamics H7)
% Last updated:     31.01.2022
% ═════════════════════════════════════════════════════════════════════════
% Version log: 
%       * 1.0. First implementation for 2D lines with 1 and 2 axis, with a
%       maximum of 5 different lines in the same plot
% ═════════════════════════════════════════════════════════════════════════

%% Usa esta sección para ordenar tus datos: 
clear; clc; close all;

% %%% Data for third plot
% x = categorical({'Mechanical', 'Propulsion', 'Sense and control', 'Marketing', 'Workspace'});
% x = reordercats(x, {'Mechanical', 'Propulsion', 'Sense and control', 'Marketing', 'Workspace'});
% 
% sponsored = [8954;  22456; 28976; 2089; 560];
% totalCost = [65009; 42333; 32334; 6508; 2000];


clear; clc; close all;

x = categorical({'Traction', 'Levitation'});
x = reordercats(x, {'Traction', 'Levitation'});

sponsored = [9000, 4500];
total     = [840, 4000];


%% ¡A dibujar!
%  Esta versión de la función solo admite gráficos de línea, para otros
%  tipos de gráfico como barras, pie charts o 3D, ponte en contacto con
%  Outreach

run plotH7.p


