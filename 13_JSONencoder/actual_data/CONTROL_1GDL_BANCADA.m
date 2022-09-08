% ╔═══════════════════════════════════════════════════════════════════════╗
% ║───────────────╔╗─╔╗───────────╔╗──────────╔╗─╔╦═══╦╗──╔╗──────────────║
% ║───────────────║║─║║───────────║║──────────║║─║║╔═╗║╚╗╔╝║──────────────║
% ║───────────────║╚═╝╠╗─╔╦══╦══╦═╣║╔══╦══╦══╗║║─║║╚═╝╠╗║║╔╝──────────────║
% ║───────────────║╔═╗║║─║║╔╗║║═╣╔╣║║╔╗║╔╗║╔╗║║║─║║╔══╝║╚╝║───────────────║
% ║───────────────║║─║║╚═╝║╚╝║║═╣║║╚╣╚╝║╚╝║╚╝║║╚═╝║║───╚╗╔╝───────────────║
% ║───────────────╚╝─╚╩═╗╔╣╔═╩══╩╝╚═╩══╩══╣╔═╝╚═══╩╝────╚╝────────────────║
% ║───────────────────╔═╝║║║──────────────║║──────────────────────────────║
% ║───────────────────╚══╝╚╝──────────────╚╝──────────────────────────────║
% ╚═══════════════════════════════════════════════════════════════════════╝

%% Valores linealizacion

s   =   tf('s');

load('COEFICIENTES_HEMS.mat');      % Terminos polinomios
load('Resultados HEMS v2.mat');

m   = 122/6;
z0  = 17.5*1e-3;
I0  = 0;
g   = 9.81;

T = 0.002;

airgap      = r.air_gap/1000;
current_I   = r.current(1,2:32);
inductance  = r.inductance;

%% Matriz linealizada auto continua
[Ac,Bc,Cc,Dc] =  linmod('R19_Modelo_nolineal_1GDL_2021', [z0],I0);

sysC = ss(Ac,Bc,Cc,Dc);
Gc   = zpk(tf(sysC))

%% matriz linealizada auto discreta
[Ad,Bd,Cd,Dd] = dlinmod('R19_Modelo_nolineal_1GDL_2021',T,[z0 0],I0);

sysD = ss(Ad,Bd,Cd,Dd,T);
Gd   = zpk(tf(sysD))

%% Calculo polos realimentacion integral
te    = 2;
osc   = 0.0432;
sosc  = -(log(osc))/sqrt(log(osc)^2+pi^2);
wn    = 4/(te*sosc);
sreal = -sosc*wn;
sconj = wn*sqrt(1-sosc^2);
polos = [sreal+sconj*1i sreal-sconj*1i sreal*20];
polos_dis = exp(T*polos);

%% Calculo K realimentacion integral continuo
Ac2 = [Ac [0; 0]];
Ac2 = [Ac2; 1 0 0];
Bc2 = [Bc; 0];

sysC2 = ss(Ac2,Bc2,eye(3),[0; 0; 0]);

K_c   = place(Ac2,Bc2,polos);

Ac_bc2 = Ac2 - Bc2*K_c;
Gc_bc  = zpk(tf(ss(Ac_bc2,Bc2,eye(3),[0; 0; 0])));


%% Calculo K realimentacion integral discreto
sysD2 = c2d(sysC2,T,'tustin');%discrete system

Ad2   = sysD2.A;
Bd2   = sysD2.B;

K_d   = place(Ad2,Bd2,polos_dis);


%% Sensor de airgap
Imax = 40;
Imin = -40;
dTSensor = 5e-4;
noiseSensor = 1.4819e-5; %Desv
resSensor = (20e-3)/(2^16); %20mm medida con 16 bits.

%% Modelo de la corriente
Rcoil = 0.319;
Lcoil = 0.019;
Vmax = 48;
Vmin = -48;

dtCurrent = 1e-4;

Kp = 25;
Ki = 100;

VarianceCurrentNoise = 0.4^2;  % Variance in A^2. Desviación típica de 0,4A.
resCurrentSensor = (80)/(2^12); %20mA

%% %%%%%%%%%%%%%%%%FILTROS (ALGUNOS DE PRUEBA)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtro primer orden posicion
options=bodeoptions;
options.FreqUnits='Hz';

fcorte_ag=(15);   
wnorm_ag=(fcorte_ag*dTSensor*2);
[b_ag,a_ag]=butter(1,wnorm_ag);
Airgap_filter=tf(b_ag,a_ag,dTSensor);
%bode(b,a,options)
%% Filtro primer orden derivada
fcorte_d=(100);   
wnorm_d=(fcorte_d*dTSensor*2);
[b_d,a_d]=butter(1,wnorm_d);
Derivative_filter=tf(b_d,a_d,dTSensor);

%% Filtro primer orden corriente
fcorte_c=(100);   
wnorm_c=(fcorte_c*dtCurrent*2);
[b_c,a_c]=butter(1,wnorm_c);
Current_filter=tf(b_c,a_c,dtCurrent);

