%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_HiSpikes.mat']);
mDataSet               = nDataSet;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])

% spkDirList             = [cellstr(repmat(SpikingHiDir,[length(SpikeHiFileList), 1])); ...
%                           cellstr(repmat(SpikingHiDir2,[length(SpikeHiFileList2), 1]))];

nDataSet               = getSimultaneousErrorSpikeDataDirList(nDataSet, mDataSet, [SpikeHiFileList; SpikeHiFileList2]);
save([TempDatDir 'SimultaneousError_HiSpikes.mat'], 'nDataSet', 'params');
