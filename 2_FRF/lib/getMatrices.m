function [K, M] = getMatrices(kL, kG, pod)
% Computes the mass (M) and stiffness (K) matrices of the 5DOF system of
% the prototype. The analytical development of the formulae can be found in
% the literature [1]. The main assumptions are:
%     (1) Neglectable transversal reluctance force components
%     (2) Neglectable drag 
%
% [1] Link al report
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 21.01.2022
% ═════════════════════════════════════════════════════════════════════════
% INPUT:
%   kL        = Equivalent stiffness of the levitation units
%               Size 6 x 1
%   kG        = Equivalent stiffness of the guidance units
%               Size 4 x 1
%   pod       = Pod characteristic data, struct divided in
%                   *mass (Mass and inertia)
%                   *brakes (Pressures, friction coefficients and forces)
%                   *levitation (Maps of forces)
%                   *guiding (Maps of forces)
%                   *propulsion (Force as a function of velocity). 
%                   *geometry (points of application of forces wrt CG)
%                   *general (simulation parameters)
% OUTPUT:
%   K         = Stiffness matrix 
%               Size N x N, with N nº dof's
%   M         = Mass matrix 
%               Size N x N
% ═════════════════════════════════════════════════════════════════════════

%%% Input check (3 inputs)
narginchk(3,3);

%%% Ensure inputs are well defined
if ~ismatrix(kL) || ~ismatrix(kG) || numel(kL) ~= 6 || ...
        numel(kG) ~= 4
    error('Equivalent stiffness matrices bad defined');
end

%%% Previous definitions
m       = pod.mass.mass * eye(2);
I       = pod.mass.inertia;

xL   = pod.geometry.x_LEV;
yL   = pod.geometry.y_LEV;
zL   = pod.geometry.z_LEV;

xG   = pod.geometry.x_G;
yG   = pod.geometry.y_G;
zG   = pod.geometry.z_G;

%%% Mass matrix
M = blkdiag(m, I);

%%% Stifness matrix
K = - [-sum(kL), 0, yL*(kL(4)+kL(5)+kL(6)-(kL(1)+kL(2)+kL(3))), xL*(kL(1)+kL(4)-(kL(6)+kL(3))), 0;
       0, kG(1)+kG(2)-kG(3)-kG(4), 0, 0, xG*(-kG(1)+kG(2)-kG(3) + kG(4));
      (kL(4)+kL(5)+kL(6) - (kL(1) + kL(2) + kL(3)))*yL, (-kG(1)-kG(2)+kG(3)+kG(4))*zG, -yL^2*sum(kL), xL*yL*(kL(1)+kL(6)-kL(3)-kL(4)), xG*zG*(kG(1)+kG(3)-kG(2)-kG(4));
      xL*(kL(1)-kL(3)+kL(4)-kL(6)),0, xL*yL*(kL(1)+kL(6) -(kL(3)+kL(4))), -xL^2*(kL(1)+kL(3)+kL(4)+kL(6)), 0;
      0, xG*(kG(1) - kG(2) - kG(3) + kG(4)),0,0, - xG^2 * (sum(kG));
      ];

end

