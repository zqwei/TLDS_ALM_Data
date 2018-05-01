%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_HiSoundSpikes.mat']);
mDataSet               = nDataSet;
load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
nDataSet               = getSimultaneousErrorSpikeData(nDataSet, mDataSet, SpikeHiSoundFileList);
save([TempDatDir 'SimultaneousError_HiSoundSpikes.mat'], 'nDataSet', 'params');