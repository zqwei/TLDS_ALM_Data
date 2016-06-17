%
% setDir.m
%
% This file sets up the basic direction information of the Ca++ imaging
% data and the spiking data
%
% version 1.0
%
% -------------------------------------------------------------------------
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 

warning('off', 'all')
addpath('../Func/plotFuncs')

% set(0, 'defaultfigureVisible','off')
set(0, 'defaultaxesTickDir', 'out')
set(0, 'defaultaxesLineWidth', 1.0)

SpikingDataDir              = '../../../Data_In_Use/Dataset_Comparison/ElectrophysiologyData/';
SpikingHiDir                = '../../../Data_In_Use/TLDS_Datasets/HidehikoData/';

SpikeFileList               = dir([SpikingDataDir '*.mat']);
SpikeHiFileList             = dir([SpikingHiDir '*.mat']);

TempDatDir                   = '../TempDat/';
if ~exist(TempDatDir, 'dir')
    mkdir(TempDatDir)
end
