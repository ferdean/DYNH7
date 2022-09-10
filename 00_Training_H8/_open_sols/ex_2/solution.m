function [] = solution(numPoints, pod)

%%% Symbolic initialization
syms I_rear I_front 

assume(abs(I_rear)  <= 40); 
assume(abs(I_front) <= 40);

%%% Extra constants unpacking
x_LEV            = pod.extra.x_LEV;    
g                = pod.extra.g;    
AG               = pod.extra.AG;    
excentricityMax  = pod.extra.excentricityMax;  

%%% Variable initialization
excentricity_map = linspace(0, excentricityMax, numPoints);
I_rear_double    = zeros(1, numPoints);
I_front_double   = zeros(1, numPoints);

for idx = 1:numPoints

    %%% Definitions
    % COG excentricity
    x_exc = excentricity_map(idx);
    
    % Forces
    F_front   = HEMSlev(AG, I_front, pod);
    F_central = HEMSlev(AG, 0, pod);
    F_rear    = HEMSlev(AG, I_rear, pod);

    % Dynamic equations
    eq_forces = 2 * (F_rear + F_front + F_central) - pod.mass.mass * g;
    eq_moment = 2 * F_front * (x_LEV + x_exc) - 2 * F_rear * (x_LEV - x_exc);
    
    %%% Easy solver
    sol = solve([eq_forces, eq_moment], [I_rear, I_front], 'MaxDegree', 3);
    
    % Numerical solution
    I_rear_double(idx)  = real(double(vpa(sol.I_rear,  6)));    
    I_front_double(idx) = real(double(vpa(sol.I_front, 6))); 
end

%%% Postprocess & plot
% Save maps
save('I_rear.mat','I_rear_double')
save('I_front.mat','I_front_double')

% Print solution 

realExcentricity = excentricity_map(floor(numel(excentricity_map)/4) + 1); 

clc;
fprintf("------------------------------------------------------\n");
fprintf("Hyperloop UPV Dynamics     -     Training exercise #2\n");
fprintf("------------------------------------------------------\n\n");

fprintf("For a nominal excentricity of %.3f m, the equilibrium \npoint is found with the following currents: \n\n", realExcentricity)
fprintf("I_front = %.2f A \t I_rear = %.2f A \n\n", I_front_double(idx), I_rear_double(idx))



% Plot map
colors = ["#a0da39", "#1fa187", "#365c8d", "k", "#0d0887", "#DADAE2"];
set(groot,'defaultAxesTickLabelInterpreter','latex'); 

fig = figure(1);

subplot(2,1,1);

plot(excentricity_map, I_front_double, 'LineWidth', 1.5, 'Color', colors(1))
hold on 
plot([realExcentricity realExcentricity], [-10 1], 'LineWidth', 1.2, 'LineStyle', '-.', 'Color', 'r')

ylabel('Current (A)', 'Interpreter','latex')
legend('\textbf{Front units}', 'Interpreter','latex')
grid on 


subplot(2,1,2); 
plot(excentricity_map, I_rear_double, 'LineWidth', 1.5, 'Color', colors(2))
hold on 
plot([realExcentricity realExcentricity], [-1 10], 'LineWidth', 1.2, 'LineStyle', '-.', 'Color', 'r')
ylabel('Current (A)', 'Interpreter','latex')
xlabel('COG excentricity (m)', 'Interpreter','latex')
legend('\textbf{Rear units}', 'Interpreter','latex')
grid on 

print(fig, 'solution','-dpdf','-r0')

end