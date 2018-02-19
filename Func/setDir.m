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

SpikingDataDir              = '../../../Data_In_Use/Dataset_Comparison/ElectrophysiologyData/delay1e3n/';
SpikingDataDir2             = '../../../Data_In_Use/TLDS_Datasets/ALMRecording_CbStim_170907/';
SpikingHiDir                = '../../../Data_In_Use/TLDS_Datasets/HidehikoData/';
SpikingHiDir2               = '../../../Data_In_Use/TLDS_Datasets/HidehikoData2/';

SpikingHiSoundDir           = '../../../Data_In_Use/TLDS_Datasets/HidehikoSoundData/';


SpikeFileList               = dir([SpikingDataDir '*.mat']);
SpikeFileList2              = dir([SpikingDataDir2 '*.mat']);
SpikeHiFileList             = dir([SpikingHiDir '*.mat']);
SpikeHiFileList2            = dir([SpikingHiDir2 '*.mat']);
SpikeHiSoundFileList        = dir([SpikingHiSoundDir '*.mat']);

TempDatDir                   = '../TempDat/';
if ~exist(TempDatDir, 'dir')
    mkdir(TempDatDir)
end
