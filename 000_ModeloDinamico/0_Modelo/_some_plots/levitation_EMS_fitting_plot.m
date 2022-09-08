p00 =       225.1;
p10 =      -46.06;
p01 =           0;
p20 =       2.212;
p11 =           0;
p02 =      0.4289;
p21 =           0;
p12 =    -0.02646;
p03 =           0;


x  = linspace(5,15,200); % Airgap [mm]
y  = linspace(-40,40,200); % Current [A]

[x,y] =  meshgrid(x,y);

F = p00 + p10.*x + p01.*y + p20.*x.^2 + p11.*x.*y + p02.*y.^2 + ...
    p21.*x.^2.*y + p12.*x.*y.^2 + p03.*y.^3;

% load("0_Modelo_11_dic\plots\Resultados.mat")

points = zeros(numel(r.force),3);
it     = 1;

for i = 1:size(r.air_gap,2)
    for j = 1:size(r.current,2)
        points(it,:) = [r.air_gap(i), r.current(j), r.force(i,j)];
        it = it+1;
    end
end

fig = figure(1);

surf(x,y,F,'EdgeColor','none')
colormap copper
hold on
scatter3(points(1:2:end,1),points(1:2:end,2),points(1:2:end,3),10,'k','filled','MarkerFaceAlpha',0.75)


title('\textbf{Levitation force data fitting}','Interpreter','latex')
xlabel('Air gap [mm]','Interpreter','latex')
ylabel('Current [A]','Interpreter','latex')
zlabel('Levitation force [N]','Interpreter','latex')

