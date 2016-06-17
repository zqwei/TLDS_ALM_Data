%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_HiSpikes.mat']);
mDataSet               = nDataSet;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
nDataSet               = getSimultaneousErrorSpikeData(nDataSet, mDataSet, SpikingHiDir, SpikeHiFileList);
save([TempDatDir 'SimultaneousError_HiSpikes.mat'], 'nDataSet', 'params');
