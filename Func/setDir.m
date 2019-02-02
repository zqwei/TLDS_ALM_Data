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

TempDatDir                   = '../TempDat/';
if ~exist(TempDatDir, 'dir')
    mkdir(TempDatDir)
end

websave([TempDatDir 'tmp.zip'], 'https://ndownloader.figshare.com/articles/7372898/versions/3');
unzip([TempDatDir 'tmp.zip'], TempDatDir);
delete([TempDatDir 'tmp.zip']);
delete([TempDatDir '*.pdf']);

if ~exist('Plots')
    mkdir('Plots')
end