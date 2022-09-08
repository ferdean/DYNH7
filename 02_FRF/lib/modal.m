function [wnHz, phi] = modal(K, M)
% Modal solution 
% ═════════════════════════════════════════════════════════════════════════
% Last updated: 21.01.2022
% ═════════════════════════════════════════════════════════════════════════
% INPUT:
%   K         = Stiffness matrix [Pa]
%               Size N x N, with N nº dof's
%   M         = Mass matrix [kg]
%               Size N x N
%   tr        = Nº vibration modes extracted [#]
%               Scalar value
% OUTPUT:
%   phi       = Modal amplitudes (vibration modes) scaled to unit mass
%               Size N x tr
%               Each column are modal amplitudes for one mode
%               Each row contains model amplitude of dof with global id (in
%               MGDL) equal to that row
%   wnHz      = Natural frequencies [Hz]
%               Size tr x 1
%               Each row corresponds to mode in same column in phi
% ═════════════════════════════════════════════════════════════════════════

%%% Input check (2 inputs)
narginchk(2,2);

%%% Ensure inputs are well defined
% K and M square matrices with same order 
if ~ismatrix(K) || ~ismatrix(M) || size(K,1)~=size(K,2) || ...
        size(M,1)~=size(M,2) || size(K,1)~=size(M,1)
    error('Stiffness/mass matrix bad defined');
end

%%% Previous calc
% Nº dofs
N      = size(K, 1);

%%% Eigen calc
[V, D, ~]      = eigs(K, M);

%%% Vibration modes scaled to unit mass
aux    = diag( V.'*(M*V) ).';               % m_r
phi    = V./repmat(sqrt(aux), [N 1]);

%%% Natural frequencies
wn     = sqrt(diag(D)); % [rad/s]
wnHz   = wn/2/pi;       % [Hz]

%%% Chopping
wnHz(wnHz<0 & wnHz>-1e-6 & wnHz<1e-6) = 0;
wnHz(imag(wnHz)~=0 & abs(imag(wnHz))<1e-3)=...
    real(wnHz(imag(wnHz)~=0 & abs(imag(wnHz))<1e-3)); 


%%% Sort natural frequencies
[wnHz, ord] = sort(wnHz, 'ascend');
phi         = phi(:, ord);

%%% Must be accomplished:
% phi.' * M * phi -> unit matrix
% phi.' * K * phi -> wn^2 (D)


end

