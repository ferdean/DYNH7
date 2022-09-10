function model = solution_2(current, airgap, force, varargin)

if ~isempty(varargin)
    if varargin{1} == 'plotflag'
        plotflag = varargin{2};

    else
        error(['Unexpected argument: ' varargin{1}])
    end
else
    plotflag = false;
end

xData = current; yData = airgap; zData = force;

ftype            = fittype('loess');
[model, ~, out]  = fit([xData, yData], zData, ftype);

residuals = out.residuals;
[~, idx]  = max(abs(residuals));

if plotflag
    figure('Renderer', 'painters', 'Position', [400 100 600 800])
    
    colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];
    set(groot,'defaultAxesTickLabelInterpreter','latex');  
    
    %%% Model plot
    subplot(211)
    p1 = plot(model, [xData, yData], zData);
    
    p1(2).Marker          = 'o';
    p1(2).MarkerFaceColor = 'k';
    p1(2).MarkerSize      = 5;
    
    legend(p1, 'model', 'experiment data', 'Location', 'NorthEast', 'Interpreter', 'latex');
    
    % Label axes
    xlabel('current (A)', 'Interpreter', 'latex')
    ylabel('airgap (mm)', 'Interpreter', 'latex')
    zlabel('force (N)'  , 'Interpreter', 'latex')
    
    grid on
    
    view(-137, 12)
    
    %%% Error plot
    
    subplot(212)
    p2 = plot(model, [xData, yData], zData, 'Style', 'Residual');
    hold on
    p2 = scatter3(xData(idx), yData(idx), residuals(idx), 'filled', 'r', 'MarkerEdgeColor', 'red');
    
    legend(p2, ['max error: ', num2str(residuals(idx)), ' N'], 'Location', 'NorthEast', 'Interpreter', 'latex');
    
    xlabel('current (A)', 'Interpreter', 'latex')
    ylabel('airgap (mm)', 'Interpreter', 'latex')
    zlabel('absolut error (N)', 'Interpreter', 'latex')
    
    grid on
    
    view(-137, 12);
end

