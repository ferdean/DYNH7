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
clear all; clc; close all;

addpath ./data
addpath ./solution

%% Data acquisition 
%%% The data of the current-airgap-force map is stored in a CSV file. The
%%% first task is to acquire (read) said data, sort it, and store it in a 
%%% struct with the following shape: 
%
% data = 
%  struct with fields:
%
%    current: [300×1 double]
%     airgap: [300×1 double]
%      force: [300×1 double]

dataFileName = "testingData.csv";

%%% YOUR CODE HERE:
%
%
%
%
%



% data = solution_1(dataFileName);

%% Force model
%%% From the data obtained in the previous section, now you need to develop
%%% a regression model, in such a way that the output of the code is a
%%% function whose inputs are current and airgap and its output is force:
%%%   
%%%              force = HEMS(airgap, current),
%%%
%%% where HEMS is a locally weighted smoothing quadratic regression
%
%   Some help: 

help fit

%%% YOUR CODE HERE:
%
%
%
%
%



% HEMS = solution_2(data.current, data.airgap, data.force);

%% Model visualization
%%% Now, plot the model. The required format of the plot is a 2x1 subplot,
%%% where the first one should show the original scattered data and the
%%% continuos own-generated model, and the second one should show the error
%%% between those two and highlight the maximum error.

figure('Renderer', 'painters', 'Position', [400 100 600 800])

colors = ["#AA4E2F", "k", "#474875", "#3f6795", "#8F8FA3", "#DADAE2"];
set(groot,'defaultAxesTickLabelInterpreter','latex');  

% First plot
subplot(211)

%%% YOUR CODE HERE:
% p1 = plot(...
%
%
%
%
% 



% [~] = solution_2(data.current, data.airgap, data.force, 'plotflag', true);