%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.  Generate raw activity of all neurons sorted in different ways
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison_V2_0

addpath('../Func');
setDir;

minNumTrialToAnalysis  = 20;

% Shuffle_Spikes_non_overlap
params.frameRate       =  29.68/2;
params.binsize         =  1/params.frameRate;
params.polein          =  -(4.37-1.22);
params.poleout         =  -(4.37-2.37);
minTime                =  params.polein - 0.5;
minTimeToAnalysis      =  round(minTime * params.frameRate);
maxTimeToAnalysis      =  round(1.5 * params.frameRate);
params.timeWindowIndexRange  = minTimeToAnalysis : maxTimeToAnalysis;
params.timeSeries      = params.timeWindowIndexRange * params.binsize;
params.minNumTrialToAnalysis =  minNumTrialToAnalysis;
params.expression      = 'None';
minFiringRate          = 5; % Hz per epoch
nDataSet               = getSpikeHiDataWithEphysTime(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(1).name    = 'Shuffle_HiSoundSpikes_non_overlap';
DataSetList(1).params  = params; 
DataSetList(1).ActiveNeuronIndex = ActiveNeuronIndex;
save([TempDatDir DataSetList(1).name '.mat'], 'nDataSet');


params.binsize         =  0.070;
params.frameRate       =  200; %Hz -- smallest bin is 0.001
minTimeToAnalysis      =  round(minTime * params.frameRate);
maxTimeToAnalysis      =  round(1.5 * params.frameRate);
params.timeWindowIndexRange  = minTimeToAnalysis : maxTimeToAnalysis;
params.timeSeries      = params.timeWindowIndexRange / params.frameRate;
nDataSet               = getSpikeHiDataWithEphysTimeAndBoxCar(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(2).name    = 'Shuffle_HiSoundSpikes_boxcar_070ms';
DataSetList(2).params  = params; 
DataSetList(2).ActiveNeuronIndex = ActiveNeuronIndex;%findHighFiringUnits(nDataSet, params, minFiringRate);
save([TempDatDir DataSetList(2).name '.mat'], 'nDataSet', '-v7.3');


params.binsize         =  0.100;
nDataSet               = getSpikeHiDataWithEphysTimeAndBoxCar(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(3).name    = 'Shuffle_HiSoundSpikes_boxcar_100ms';
DataSetList(3).params  = params; 
DataSetList(3).ActiveNeuronIndex = ActiveNeuronIndex;%findHighFiringUnits(nDataSet, params, minFiringRate);
save([TempDatDir DataSetList(3).name '.mat'], 'nDataSet', '-v7.3');

params.binsize         =  0.150;
nDataSet               = getSpikeHiDataWithEphysTimeAndBoxCar(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(4).name    = 'Shuffle_HiSoundSpikes_boxcar_150ms';
DataSetList(4).params  = params; 
DataSetList(4).ActiveNeuronIndex = ActiveNeuronIndex;%findHighFiringUnits(nDataSet, params, minFiringRate);
save([TempDatDir DataSetList(4).name '.mat'], 'nDataSet', '-v7.3');

params.binsize         =  0.200;
nDataSet               = getSpikeHiDataWithEphysTimeAndBoxCar(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(5).name    = 'Shuffle_HiSoundSpikes_boxcar_200ms';
DataSetList(5).params  = params; 
DataSetList(5).ActiveNeuronIndex = ActiveNeuronIndex;%findHighFiringUnits(nDataSet, params, minFiringRate);
save([TempDatDir DataSetList(5).name '.mat'], 'nDataSet', '-v7.3');

params.binsize         =  0.250;
nDataSet               = getSpikeHiDataWithEphysTimeAndBoxCar(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
DataSetList(6).name    = 'Shuffle_HiSoundSpikes_boxcar_250ms';
DataSetList(6).params  = params; 
DataSetList(6).ActiveNeuronIndex = ActiveNeuronIndex;%findHighFiringUnits(nDataSet, params, minFiringRate);
save([TempDatDir DataSetList(6).name '.mat'], 'nDataSet', '-v7.3');



save([TempDatDir 'DataListEphysHiSound.mat'], 'DataSetList');
