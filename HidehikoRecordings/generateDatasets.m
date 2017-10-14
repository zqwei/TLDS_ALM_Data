%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0.  Generate raw activity of all neurons sorted in different ways
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison_V2_0

addpath('../Func');
setDir;

minNumTrialToAnalysis  = 20;
params.frameRate       =  29.68/2;
params.binsize         =  1/params.frameRate;
params.polein          =  -2.6;
params.poleout         =  -1.3;
minTimeToAnalysis      =  round(-3.1 * params.frameRate);
maxTimeToAnalysis      =  round(2.0 * params.frameRate);
params.timeWindowIndexRange  = minTimeToAnalysis : maxTimeToAnalysis;
params.timeSeries      = params.timeWindowIndexRange * params.binsize;
params.minNumTrialToAnalysis =  minNumTrialToAnalysis;
params.expression      = 'None';
minFiringRate          = 5; % Hz per epoch
nDataSet               = getSpikeHiDataWithEphysTime(SpikingHiDir, SpikeHiFileList, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
CR                     = getHiBehavioralPerformance(SpikingHiDir, SpikeHiFileList);

nDataSetOld            = nDataSet;
ActiveNeuronIndexOld   = ActiveNeuronIndex;
CROld                  = CR;

nDataSet               = getSpikeHiDataWithEphysTime(SpikingHiDir2, SpikeHiFileList2, params.minNumTrialToAnalysis, params.timeSeries, params.binsize);                                  
ActiveNeuronIndex      = findHighFiringUnits(nDataSet, params, minFiringRate);
CR                     = getHiBehavioralPerformance(SpikingHiDir2, SpikeHiFileList2);
for nUnit = 1:length(nDataSet)
    nDataSet(nUnit).sessionIndex  = nDataSet(nUnit).sessionIndex + length(SpikeHiFileList);
end

nDataSet               = [nDataSetOld; nDataSet];
ActiveNeuronIndex      = [ActiveNeuronIndexOld; ActiveNeuronIndex];
CR                     = [CROld; CR];
save([TempDatDir 'Shuffle_HiSpikes.mat'], 'nDataSet', 'params', 'ActiveNeuronIndex', 'CR');
