%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.  Generate raw activity of all neurons sorted in different ways
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison_V2_0

addpath('../Func');
setDir;

minNumTrialToAnalysis  = 20;
params.frameRate       =  29.68/2;
params.binsize         =  1/params.frameRate;
% % % Sampling_start:    1.22s
% % % Delay_start:       2.37s
% % % Cue_start:         4.37s
params.polein          =  -(4.37-1.22);
params.poleout         =  -(4.37-2.37);
minTime                =  params.polein - 0.5;
minTimeToAnalysis      =  round(minTime * params.frameRate);
maxTimeToAnalysis      =  round(2.0 * params.frameRate);
params.timeWindowIndexRange  = minTimeToAnalysis : maxTimeToAnalysis;
params.timeSeries      = params.timeWindowIndexRange * params.binsize;
params.minNumTrialToAnalysis =  minNumTrialToAnalysis;
params.expression      = 'None';
minFiringRate          = 5; % Hz per epoch
nDataSet               = getSpikeHiDataWithEphysTime(SpikingHiSoundDir, SpikeHiSoundFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
CR                     = getHiBehavioralPerformance(SpikingHiDir, SpikeHiFileList);

save([TempDatDir 'Shuffle_HiSoundSpikes.mat'], 'nDataSet', 'params', 'ActiveNeuronIndex', 'CR');
