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
%% Script initialization (for loop)
clear all; clc; close all;

addpath lib
addpath constants

%%% The reader is encouraged to use symbolic calculus to solve this 
%%% exercise (Symbolic Mathematics Toolbox).

syms I_rear I_front 

% Note that the HEMS current is bounded by [-40, 40] A
assume(abs(I_rear)  <= 40); 
assume(abs(I_front) <= 40);

% Pod constants
global pod;
constants_H7()

% Additional needed constants
pod.extra.x_LEV           = 0.527;        % [m]      - Nominal position of units
pod.extra.g               = 9.81;         % [m/s^2]  - Gravity
pod.extra.AG              = 17.5;         % [mm]     - Nominal airgap
pod.extra.excentricityMax = 7.5e-2;       % [m]      - Maximum expected excentricity

numPoints = 50;

%%% YOUR CODE HERE:
%
%
%
%
%
%
%
%
%
%
%
%
%

% solution(numPoints, pod)

