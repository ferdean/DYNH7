function [wHz, uDOF] = FRF(K,M,phi,input,output)
    
    

    nDOF = numel(input); % 5

    % Modal transformation
    Mq  = phi.'*M*phi;
    Kq  = phi.'*K*phi;

    % Frequency domain
    wHz = 0:0.01:15;
    
    Fz = input(1) * ones(length(wHz),1);
    Fy = input(2) * ones(length(wHz),1);
    Mx = input(3) * ones(length(wHz),1);
    My = input(4) * ones(length(wHz),1);
    Mz = input(5) * ones(length(wHz),1);
    
    uDOF    = zeros(nDOF,length(wHz));
    
    for i_w = 1:length(wHz)   
            F_GDL = zeros(nDOF, 1);
    
            F_GDL(1) = Fz(i_w);
            F_GDL(2) = Fy(i_w);
            F_GDL(3) = Mx(i_w);
            F_GDL(4) = My(i_w);
            F_GDL(5) = Mz(i_w);
    
            Qq = phi.' * F_GDL;
        
            w = wHz(i_w) * 2 * pi;
    
            qModes = (-w^2*Mq + Kq ) \ Qq; % nModes x 1
        
            uDOF(:,i_w) = phi * qModes; % N x 1
    end

    subplot(2,1,1)
    semilogy(wHz,abs(uDOF(find(output),:)),'k')
    haxis = gca; 
    % Font size
    FS    = 13; 
    % Axis format
    set(gca, 'FontName', 'TimesNewRoman');
    hYLabel          = ylabel('$\mid  u(f) \mid$','Interpreter','latex');
    hXLabel          = xlabel('Frecuencia (f) [Hz]','Interpreter','latex');
    haxis.Box        = 'on';
    haxis.TickDir    = 'out';
    haxis.TickLength = [.02 .02];
    haxis.XMinorTick = 'on';
    haxis.YMinorTick = 'on';
    haxis.YGrid      = 'on';
    haxis.XMinorGrid = 'on';
    haxis.YMinorGrid = 'on';
    haxis.XGrid      = 'on';
    haxis.XColor     = [.0 .0 .0];
    haxis.YColor     = [.0 .0 .0];
    haxis.LineWidth  = 0.75;
    haxis.FontName   = 'Palatine';
    haxis.FontSize   = 0.65*FS;
    hXLabel.FontSize = 0.85*FS;
    hYLabel.FontSize = 0.85*FS;

    subplot(2,1,2)
    plot(wHz,angle(uDOF(find(output),:)),'k')
    haxis = gca; 
    % Font size
    FS    = 13; 
    % Axis format
    set(gca, 'FontName', 'TimesNewRoman');
    hYLabel          = ylabel('$\alpha(f)$','Interpreter','latex');
    hXLabel          = xlabel('Frecuencia (f) [Hz]','Interpreter','latex');
    haxis.Box        = 'on';
    haxis.TickDir    = 'out';
    haxis.TickLength = [.02 .02];
    haxis.XMinorTick = 'on';
    haxis.YMinorTick = 'on';
    haxis.YGrid      = 'on';
    haxis.XMinorGrid = 'on';
    haxis.YMinorGrid = 'on';
    haxis.XGrid      = 'on';
    haxis.XColor     = [.0 .0 .0];
    haxis.YColor     = [.0 .0 .0];
    haxis.LineWidth  = 0.75;
    haxis.FontName   = 'Palatine';
    haxis.FontSize   = 0.65*FS;
    hXLabel.FontSize = 0.85*FS;
    hYLabel.FontSize = 0.85*FS;

end