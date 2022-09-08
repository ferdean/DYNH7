function datamesh = plotear(v, plotflag)
%%% Esta funcion es de Javi L, no esta validada aun
g.current=[];
g.airgap=[];
g.force=[];

%% V1
% k=1;
% for i=1:length(v(k).s)
%     if ~isempty(v(k).s(i).force)
%         g.current=[g.current;v(k).s(i).current];
%         g.airgap=[g.airgap;v(k).s(i).airgap];
%         g.force=[g.force;v(k).s(i).force];
%     end
% end

%% V2​
k=1;
for i=1:length(v(k).s)
    if ~isempty(v(k).s(i).force)
        g.current=[g.current;v(k).s(i).current];
        g.airgap=[g.airgap;v(k).s(i).airgap];
        g.force=[g.force;v(k).s(i).force];
    end
end

%% V3​
k=2;
for i=1:length(v(k).s)
    if ~isempty(v(k).s(i).force)
        g.current=[g.current;v(k).s(i).current];
        g.airgap=[g.airgap;v(k).s(i).airgap];
        g.force=[g.force;v(k).s(i).force];
    end
end

%% V4
% 
% k=4;
% for i=1:length(v(k).s)
%     if ~isempty(v(k).s(i).force)
%         g.current=[g.current;v(k).s(i).current];
%         g.airgap=[g.airgap;v(k).s(i).airgap];
%         g.force=[g.force;v(k).s(i).force];
%     end
% end

%% simulacion

if plotflag 
        
    plot3(g.airgap,g.current,g.force,'o');
    
    %% Interpolar
    F=scatteredInterpolant(g.airgap,g.current,g.force);
    F.Method='natural';
    F=scatteredInterpolant(g.airgap,g.current,g.force);
    hold on
    [a,c]=meshgrid(12:0.05:23,-40:0.05:40);
    mesh(a,c,F(a,c));

end

datamesh = g;
end