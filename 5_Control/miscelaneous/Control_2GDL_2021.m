%% Valores linealizacion
s   =   tf('s');

addpath('lib')
addpath('constants')

global pod;
constants_H7()

load('COEFICIENTES_HEMS.mat'); % Terminos polinomios
load('Resultados HEMS v2.mat');

m           = pod.mass.mass;
Iyy         = pod.mass.inertia(2,2);
x_lev       = pod.geometry.x_LEV;
z_lev       = pod.geometry.z_LEV;
z_0         = 18e-3;
z_ini       = z_0 + z_lev;
theta0      = 0;
I1_0        = 0;
I2_0        = 0;
I3_0        = 0;
g           = 9.81;

airgap      =   r.air_gap/1000;
current     =   r.current;
current_I   =   r.current(1,2:32);
force       =   r.force;
inductance  =   r.inductance;
T           =   0.001;

%% INCIALIZACION MODELO FERRAN

nominal_airgap      = 18e-3;  % [m]

% Initial conditions
initial_conds.x_0   = [0, 0, (nominal_airgap + pod.geometry.z_LEV)];
initial_conds.v_0   = [0, 0, 0];
initial_conds.ang_0 = [0, 0, 0];
initial_conds.w_0   = [0, 0, 0];

% Simulation conditions 
%dtMax = 1e-3;   % [s] 
dtMax = T;      % [s]
TMax  = 10;     % [s]

pod.brakes.emergency_flag    = 0;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)
pod.general.propulsion_on    = 1;

%% Matriz linealizada auto continua
[Ac,Bc,Cc,Dc] =  linmod('Modelo_nolineal_2GDL_2021', [z_ini,0,theta0,0],[I1_0,I2_0,I3_0]);

sysC          = ss(Ac,Bc,Cc,Dc);
Gc            = zpk(tf(sysC))

%% matriz linealizada auto discreta
[Ad,Bd,Cd,Dd] = dlinmod('Modelo_nolineal_2GDL_2021',T,[z_ini,0,theta0,0],[I1_0,I2_0,I3_0]);

sysD = ss(Ad,Bd,Cd,Dd,T);
Gd   = zpk(tf(sysD))

%% Matriz linealizada auto continua MODELO 3 DOF (NO ACTUALIZADO)
%[Ac3,Bc3,Cc3,Dc3] =  linmod('Linealizacion_modelo_3DOF', [[0,0],[0,z_ini],[0,0],theta0,0,0],[I1_0,I2_0,I3_0]);
%[Ac3,Bc3,Cc3,Dc3] =  linmod('Linealizacion_modelo_3DOF', [theta0,0,0,[0,z_ini],[0,0],[0,0]],[I1_0,I2_0,I3_0]);
%[Ac3,Bc3,Cc3,Dc3] =  linmod('Linealizacion_modelo_3DOF', [z_ini,0,theta0,0],[I1_0,I2_0,I3_0]);
%sysC3 = ss(Ac3,Bc3,Cc3,Dc3);
%Gc3 = zpk(tf(sysC3))
%% Calculo polos realimentacion integral
te = 2;
osc = 0.15;
%te = 2;        %%FUNCIONAN PARA MODELO DISTANCIA Y CORRIENTE SIN IDUCTANCIA
%osc = 0.1;
sosc=-(log(osc))/sqrt(log(osc)^2+pi^2);
wn=4/(te*sosc);
sreal=-sosc*wn;
sconj=wn*sqrt(1-sosc^2);
polos = [sreal+sconj*1i sreal-sconj*1i sreal*10 (sreal*10)+5 (sreal*10)+10 (sreal*10)+15]
%polos = [sreal+sconj*1i sreal-sconj*1i sreal*10 (sreal*10)+5 (sreal*10)+10 (sreal*10)+15]
polos_dis = exp(T*polos);
%% Calculo K realimentacion integral continuo
Ac2 = [Ac [0 0; 0 0;0 0;0 0]];
Ac2 = [Ac2; 1 0 0 0 0 0; 0 0 1 0 0 0];
Bc2 = [Bc; [0,0,0]; [0,0,0]];
Cc2 = [Cc [0 0; 0 0;0 0;0 0]];
Cc2 = [Cc2 ; 1 0 0 0 0 0; 0 0 1 0 0 0];
D=[0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];

sysC2 = ss(Ac2,Bc2,Cc2,D);

K_c = place(Ac2,Bc2,polos)
%K_c(3,1:4)=K_c(3,1:4)*0.75
%K_c(3,1:4)=K_c(3,1:4)*0.65

Ac_bc2 = Ac2 - Bc2*K_c;
Gc_bc = zpk(tf(ss(Ac_bc2,Bc2,Cc2,D)));

%% Calculo K realimentacion integral discreto
% Ad2 = [Ad [0; 0]];
% Ad2 = [Ad2; 1 0 0];
% Bd2 = [Bd; 0];

sysD2 = c2d(sysC2,T,'tustin');%discrete system
Ad2 = sysD2.A;
Bd2 = sysD2.B;

K_d = place(Ad2,Bd2,polos_dis);
%Ad_bc2 = Ad2-Bd2*K_d;
%Gd_bc = zpk(tf(ss(Ad_bc2,Bd2,eye(3),[0; 0; 0],T)))
%% more
Imax = 40;
Imin = -40;
delayI = 0.01;
dTSensor = 5e-4;
%noiseSensor = 0.03*1e-3;
noiseSensor = 0.05*1e-3;
resSensor = 0.01*1e-3;
zIabs = 18;

filterConstant = 30;
thetafilter = 40;
nDerivative = 10;

%% Modelo de la corriente
Rcoil = 0.242;
%Lcoil = Rcoil*0.1;
%Lcoil = 5/1000;
%Lcoil = 1;
Lcoil = 0.002;

dtCurrent = 1e-4;

%Kp = 25;
Kp = 25;
Ki = 100;
%Kp = 10;
%Ki = 100;

tauFilterCurrent = 0.001;

currentSensorNoise = 0.06^2;  % Variance in A^2

resCurrent=156.11/7200;


%%%%%%%%%%%%%%%%%%FILTROS (ALGUNOS DE PRUEBA)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filtro primer orden posicion
options=bodeoptions;
options.FreqUnits='Hz';

fcorte=(50);   
wnorm=(fcorte*dTSensor*2);
[b,a]=butter(1,wnorm);
Fd_1=tf(b,a,dTSensor)
%bode(b,a,options)

%% Filtro primer orden corriente
fcorte_c=(100);   
wnorm_c=(fcorte_c*dtCurrent*2);
[b_c,a_c]=butter(1,wnorm_c);
Fd_1c=tf(b_c,a_c,dtCurrent);

%% Filtro segundo orden posicion
fcorte2=(100);   
wnorm2=(fcorte2*dTSensor*2);
[b2,a2]=butter(2,wnorm2);
Fd_2=tf(b2,a2,dTSensor);
%syms s
%% Filtro segundo orden corriente
fcorte2_c=(1000);   
wnorm2_c=(fcorte2_c*dtCurrent*2);
[b2_c,a2_c]=butter(2,wnorm2_c);




Fd_2c=tf(b2_c,a2_c,dtCurrent);
