air_gaps_discrete = [11, 15, 18, 20, 23];
currents_discrete = [-40, -20, 0, 20, 40];

current_map       = -40:2:40;
ag_map            = 10:1:25;

force_AG = zeros(length(air_gaps_discrete),length(current_map));

it = 0;

for ag_i = 1:length(air_gaps_discrete)
    airgap = air_gaps_discrete(ag_i);

    for i = 1:length(current_map)
        intensity = current_map(i);

        results_AG = sim('tests_and_trash.slx');
        
        force_AG(ag_i, i) = max(results_AG.F_LEV.Data);
    end
    it = it + 1;
    fprintf('Iteration: ')
    fprintf(num2str(it))
    fprintf('\n')
end

force_CUR = zeros(length(ag_map), length(currents_discrete));

for i_i = 1:length(currents_discrete)
    intensity = currents_discrete(i_i);

    for ag_i = 1:length(ag_map)
        airgap = ag_map(ag_i);

        results_CUR = sim('tests_and_trash.slx');
        
        force_CUR(ag_i, i_i) = max(results_CUR.F_LEV.Data);
    end
    it = it + 1;
    fprintf('Iteration: ')
    fprintf(num2str(it))
    fprintf('\n')
end


save('F_LEV_airgap.mat','force_AG')
save('F_LEV_current.mat','force_CUR')