%% Valores linealizacion
% clear all;

addpath('lib')
addpath('constants')
addpath('variables')

s = tf('s');

load('COEFICIENTES_HEMS.mat'); % Terminos polinomios
load('COEFICIENTES_EMS.mat');  % Terminos polinomios
load('Resultados HEMS v2.mat');

global pod;

constants_H7()

m   = pod.mass.mass;
Ixx = pod.mass.inertia(1,1);
Iyy = pod.mass.inertia(2,2);
Izz = pod.mass.inertia(3,3);

pod.mass.inertia(1,3) = 0;
pod.mass.inertia(3,1) = 0;

x_lev_front = pod.geometry.x_LEV_front;
x_lev_rear  = pod.geometry.x_LEV_rear;
x_lev       = 0.5 * (x_lev_front + x_lev_rear);

z_lev       = pod.geometry.z_LEV;
y_lev       = pod.geometry.y_LEV;

z_g         = pod.geometry.z_G;
y_g         = pod.geometry.y_G;

x_g_front   = pod.geometry.x_G_front;
x_g_rear    = pod.geometry.x_G_rear;
x_g         = 0.5 * (x_g_front + x_g_rear);


AG0         = 10e-3;
z_0         = 17.5e-3;
z_ini       = z_0 + z_lev;
y_ini       = 0;
theta0      = 0;
phi0        = 0;
thita0      = 0;
g           = 9.81;

airgap      = r.air_gap/1000;
current     = r.current;
current_I   = r.current(1,2:32);
force       = r.force;
inductance  = r.inductance;

T = 0.001;
%% 6 DOF simulation 


% Initial conditions
initial_conds.x_0   = [0, 0, z_ini];
initial_conds.v_0   = [0, 0, 0];
initial_conds.ang_0 = [0, 0, 0]; 
initial_conds.w_0   = [0, 0, 0];

% Simulation conditions 
%dtMax = T;  % [s] 
%TMax  = 20;     % [s]

pod.brakes.emergency_flag    = 0;
pod.brakes.working_actuators = [1 1 1 1]; % [1 1 1 1] = all working
                                          % [0 1 1 1] = malfunction in (1)
pod.general.propulsion_on    = 0;

beta = 20;                                % Airgap measure acceptance tolerance [-]

%% Matriz linealizada auto continua

estados_0       = [z_ini,0,y_ini,0,theta0,0,phi0,0,thita0,0];
corrientes_0    = zeros(1,10);
[Ac,Bc,Cc,Dc]   = linmod('EDU_modelo_nolineal_5GDL_2021', estados_0, corrientes_0);
sysC            = ss(Ac,Bc,Cc,Dc);
Gc              = zpk(tf(sysC));

%% matriz linealizada auto discreta

[Ad,Bd,Cd,Dd] = dlinmod('EDU_modelo_nolineal_5GDL_2021',T, estados_0,corrientes_0);
sysD          = ss(Ad,Bd,Cd,Dd,T);
Gd            = zpk(tf(sysD))

%% REALIMENTACION ESTADO
te        = 2;
osc       = 0.05;
dis_aux   = 7;

sosc      = -(log(osc))/sqrt(log(osc)^2+pi^2);
wn        = 4/(te*sosc);
sreal     = -sosc*wn;
sconj     = wn*sqrt(1-sosc^2);

polos_EST = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7];

K_EST     = place(Ac,Bc,polos_EST);

sysEST    = ss(Ac,Bc,Cc,Dc);
G_EST     = zpk(tf(sysEST));

%% Integral solo posicion Z (INT1)
polos_INT1 = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7 (sreal*dis_aux)-8];

A_aux=zeros(10,1);
Ac2 = [Ac A_aux];
C_aux=zeros(1,11);
C_aux(1,1)=1;
Ac2 = [Ac2; C_aux];
B_aux=zeros(1,10);
Bc2 = [Bc; B_aux];

K_INT1=place(Ac2,Bc2,polos_INT1);

%% Integral posicion Z e Y (INT 2)
polos_INT2 = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7 (sreal*dis_aux)-8 (sreal*dis_aux)-9];

A_aux=zeros(10,2);
Ac2 = [Ac A_aux];
C_aux=zeros(2,12);
C_aux(1,1)=1;
C_aux(2,3)=1;
Ac2 = [Ac2; C_aux];
B_aux=zeros(2,10);
Bc2 = [Bc; B_aux];

K_INT2=place(Ac2,Bc2,polos_INT2);

%% Integral posicion Z e Y / ROT Y (INT 3)
polos_INT3 = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7 (sreal*dis_aux)-8 (sreal*dis_aux)-9 (sreal*dis_aux)-10];

A_aux=zeros(10,3);
Ac2 = [Ac A_aux];
C_aux=zeros(3,13);
C_aux(1,1)=1;
C_aux(2,3)=1;
C_aux(3,5)=1;
Ac2 = [Ac2; C_aux];
B_aux=zeros(3,10);
Bc2 = [Bc; B_aux];

K_INT3=place(Ac2,Bc2,polos_INT3);

%% Integral posicion Z e Y / ROT Y e Z (INT 4)
polos_INT4 = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7 (sreal*dis_aux)-8 (sreal*dis_aux)-9 (sreal*dis_aux)-10 (sreal*dis_aux)-11];

A_aux=zeros(10,4);
Ac2 = [Ac A_aux];
C_aux=zeros(4,14);
C_aux(1,1)=1;
C_aux(2,3)=1;
C_aux(3,5)=1;
C_aux(4,7)=1;
Ac2 = [Ac2; C_aux];
B_aux=zeros(4,10);
Bc2 = [Bc; B_aux];

K_INT4=place(Ac2,Bc2,polos_INT4);

%% Integral posicion Z e Y / ROT Y e Z e X (INT 5)
polos_INT5 = [sreal+sconj*1i sreal-sconj*1i sreal*dis_aux (sreal*dis_aux)-1 (sreal*dis_aux)-2  (sreal*dis_aux)-3 (sreal*dis_aux)-4 (sreal*dis_aux)-5 (sreal*dis_aux)-6 (sreal*dis_aux)-7 (sreal*dis_aux)-8 (sreal*dis_aux)-9 (sreal*dis_aux)-10 (sreal*dis_aux)-11 (sreal*dis_aux)-12];

A_aux=zeros(10,5);
Ac2 = [Ac A_aux];
C_aux=zeros(5,15);
C_aux(1,1)=1;
C_aux(2,3)=1;
C_aux(3,5)=1;
C_aux(4,7)=1;
C_aux(5,9)=1;
Ac2 = [Ac2; C_aux];
B_aux=zeros(5,10);
Bc2 = [Bc; B_aux];

K_INT5=place(Ac2,Bc2,polos_INT5);
%% more
Imax = 40;
Imin = -40;
delayI = 0.01;
dTSensor = 5e-4;
%noiseSensor = 0.05*1e-3;
noiseSensor = 0.02*1e-3;
resSensor = 0.01*1e-3;
zIabs = 18;

filterConstant = 30;
thetafilter = 30;
%filterConstant = 20;
%thetafilter = 20;
%velfilter=10;
velfilter=10;
nDerivative = 10;

%% Modelo de la corriente
Rcoil = 0.242;
Lcoil = Rcoil*0.1;
%Lcoil = 5/1000;
%Lcoil = 1;
%Lcoil = 0.002;

dtCurrent = 1e-4;

%Kp = 25;
Kp = 25;
%Ki = 100;
Ki = 50;

KpI=10;
KiI=40;
%Kp = 10;
%Ki = 100;

tauFilterCurrent = 0.001;

currentSensorNoise = 0.06^2;  % Variance in A^2

resCurrent=156.11/7200;


%%%%%%%%%%%%%%%%%%FILTROS (ALGUNOS DE PRUEBA)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filtro primer orden posicion
options=bodeoptions;
options.FreqUnits='Hz';

fcorte=(5);   
wnorm=(fcorte*dTSensor*2);
[b,a]=butter(1,wnorm);
Fd_1=tf(b,a,dTSensor);
%bode(b,a,options)

%% Filtro primer orden corriente
fcorte_c=(100);   
wnorm_c=(fcorte_c*dtCurrent*2);
[b_c,a_c]=butter(1,wnorm_c);
Fd_1c=tf(b_c,a_c,dtCurrent);

%% Filtro segundo orden posicion
fcorte2=(5);   
wnorm2=(fcorte2*dTSensor*2);
[b2,a2]=butter(2,wnorm2);
Fd_2=tf(b2,a2,dTSensor);
%syms s
%% Filtro segundo orden corriente
fcorte2_c=(1000);   
wnorm2_c=(fcorte2_c*dtCurrent*2);
[b2_c,a2_c]=butter(2,wnorm2_c);
Fd_2c=tf(b2_c,a2_c,dtCurrent);
