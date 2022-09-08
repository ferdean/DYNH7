%%% Data for first plot
addpath('testdata')
load('current_data.mat')

time = current_data.time;

current = current_data.current(:,1);
voltage = current_data.current(:,3);

%%% Data for second plot
addpath('testdata')
load('frenoACC.mat')

time = simfreno.velocidad(1).tiempo;

brakingForce = zeros(6,20);
smthBF       = zeros(6,20);

for idx = 1:5
   brakingForce(idx, :) = simfreno.velocidad(idx).fuerza_x'; 
   smthBF(idx, :)       = smooth(smooth(simfreno.velocidad(idx).fuerza_x'));
end

smthBF = smthBF.';

%%% Data for third plot
x = categorical({'Mechanical', 'Propulsion', 'Sense and control', 'Marketing', 'Workspace'});
x = reordercats(x, {'Mechanical', 'Propulsion', 'Sense and control', 'Marketing', 'Workspace'});

sponsored = [8954;  22456; 28976; 2089; 560];
totalCost = [65009; 42333; 32334; 6508; 2000];