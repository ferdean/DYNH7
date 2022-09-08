function [Lmodel] = HEMSmodel(I_map)

a =   -0.008752;
b =      0.1609;
c =       1.389;
d =           0;
e =     0.01042;

Lmodel = a .* tanh(b.*I_map - c) + e;

end

