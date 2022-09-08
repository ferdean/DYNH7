function [v, F] = plotear (simfreno)
for i=1:length(simfreno.velocidad)
    v(i)=simfreno.velocidad(i).valorvelocidad;
    F(i)=mean(simfreno.velocidad(i).fuerza_x(10:end));
end

