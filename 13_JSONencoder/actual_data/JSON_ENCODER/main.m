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

addpath files
% addpath templates
addpath lib

%% Script body

% JSON decoding
dataAGfilt  = jsondecoder("Airgap_Filter_Descriptor");
dataCUfilt  = jsondecoder("Current_Filter_Descriptor");
dataDEfilt  = jsondecoder("Derivative_Filter_Descriptor");
dataDE      = jsondecoder("Derivative_Descriptor");
dataPI      = jsondecoder("PI_Descriptor");
dataPID     = jsondecoder("PID_Descriptor");

% Data manipulation
dataDE.body.coef = [];

dataAGfilt.body.inputs.coef  = [];
dataAGfilt.body.outputs.coef = [];

dataCUfilt.body.inputs.coef  = [];
dataCUfilt.body.outputs.coef = [];

dataDEfilt.body.inputs.coef  = [];
dataDEfilt.body.outputs.coef = [];

dataPI.body.coef.k_p = 0.0;
dataPI.body.coef.k_i = 0.0;
dataPI.body.sat.sat_inf = 0.0;
dataPI.body.sat.sat_sup = 0.0;

dataPID.body.coef.k_p = 0.0;
dataPID.body.coef.k_i = 0.0;
dataPID.body.coef.k_d = 0.0;
dataPID.body.sat.sat_inf = 0.0;
dataPID.body.sat.sat_sup = 0.0;

% JSON encoding
jsonencoder(dataAGfilt, "Airgap_Filter_Descriptor");
jsonencoder(dataCUfilt, "Current_Filter_Descriptor");
jsonencoder(dataDEfilt, "Derivative_Filter_Descriptor");
jsonencoder(dataDE,  "Derivative_Descriptor");
jsonencoder(dataPI,  "PI_Descriptor");
jsonencoder(dataPID, "PID_Descriptor");



