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

%% Script initialization

clear all; close all; clc;

addpath JSON_ENCODER\lib
addpath JSON_ENCODER\files

run CONTROL_1GDL_BANCADA 

clc;

%% JSON creation

%%% JSON decoding
dataAGfilt  = jsondecoder("Airgap_Filter_Descriptor");
dataCUfilt  = jsondecoder("Current_Filter_Descriptor");
dataDEfilt  = jsondecoder("Derivative_Filter_Descriptor");
dataDE      = jsondecoder("Derivative_Descriptor");
dataPI      = jsondecoder("PI_Descriptor");
dataPID     = jsondecoder("PID_Descriptor"); 

%%% Fill vectors with 0 (if needed, no need to comment if not)
b_ag(end+1:6) = 0;
a_ag(end+1:6) = 0;
b_c(end+1:6)  = 0;
a_c(end+1:6)  = 0;
b_d(end+1:6)  = 0;
a_d(end+1:6)  = 0;

%%% Avoid MATLAB's negative zero
neg_a_c                 = - a_c;
neg_a_c(neg_a_c == 0)   = 0;
neg_a_ag                = - a_ag;
neg_a_ag(neg_a_ag == 0) = 0;
neg_a_d                 = - a_d;
neg_a_d(neg_a_d == 0)   = 0;

%%% Data manipulation
dataAGfilt.body.inputs.coef  = single(b_ag);
dataAGfilt.body.outputs.coef = single(neg_a_ag(2:end));

dataCUfilt.body.inputs.coef  = single(b_c);
dataCUfilt.body.outputs.coef = single(neg_a_c(2:end));

dataDEfilt.body.inputs.coef  = single(b_d);
dataDEfilt.body.outputs.coef = single(neg_a_d(2:end));

dataDE.body.coef             = single([1, 1, 1]);

dataPI.body.coef.k_p         = single(Kp);
dataPI.body.coef.k_i         = single(Ki);
dataPI.body.sat.sat_inf      = single(Vmin);
dataPI.body.sat.sat_sup      = single(Vmax);

dataPID.body.coef.k_p        = single(K_d(1));
dataPID.body.coef.k_i        = single(K_d(3));
dataPID.body.coef.k_d        = single(K_d(2));
dataPID.body.sat.sat_inf     = single(Imin);
dataPID.body.sat.sat_sup     = single(Imax);

%%% JSON enconding
jsonencoder(dataAGfilt, "Airgap_Filter_Descriptor");
jsonencoder(dataCUfilt, "Current_Filter_Descriptor");
jsonencoder(dataDEfilt, "Derivative_Filter_Descriptor");
jsonencoder(dataDE,  "Derivative_Descriptor");
jsonencoder(dataPI,  "PI_Descriptor");
jsonencoder(dataPID, "PID_Descriptor");



