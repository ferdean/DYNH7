v_1 = v1.Data;
v_2 = v2.Data;
v_3 = v3.Data;

voltage_vector = [v_1, v_2, v_3];

time = v1.Time;


set(groot,'defaultAxesTickLabelInterpreter','latex');  
figure(1)

plot(time, voltage_vector(:,3), "Color", 'k', 'LineWidth', 1.5)
hold on
plot(time, voltage_vector(:,2), "Color", '#AA4E2F', 'LineWidth', 1.5)
hold on
plot(time, voltage_vector(:,1), "Color", '#474875', 'LineWidth', 1.5)

xlabel('time (s)', 'Interpreter','latex')
ylabel('voltage (V)', 'Interpreter','latex')

legend('Rear unit', 'Central unit', 'Front unit', ...
    'interpreter', 'latex')

ylim([-20 20])

grid on