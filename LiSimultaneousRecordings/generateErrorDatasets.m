%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_Spikes.mat']);
mDataSet               = nDataSet;
load([TempDatDir 'Simultaneous_Spikes.mat'])
nDataSet               = getSimultaneousErrorSpikeData(nDataSet, mDataSet, [SpikeFileList; SpikeFileList2]);
save([TempDatDir 'SimultaneousError_Spikes.mat'], 'nDataSet', 'params');