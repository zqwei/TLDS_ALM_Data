%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

% Rename the DataSetList Names as the simultaneously recorded datasets
minUnitsSession        = 6;
minRate                = 5;
perMinRate             = 0.4; % percentage of min Rate in an entire trial
ROCThres               = 0.50;
minTrialRatio          = 2.0;

load([TempDatDir 'Shuffle_Spikes.mat']);
params.ROCIndex          = ROCPop(nDataSet, params);
params.ActiveNeuronIndex = ActiveNeuronIndex;
[nDataSet, kickOutIndex] = ...
                        getSimultaneousSpikeData(nDataSet, ...
                        params,...
                        minRate, perMinRate, ROCThres, ...
                        minUnitsSession);
save([TempDatDir 'Simultaneous_Spikes.mat'], 'nDataSet', 'kickOutIndex', 'params', 'ActiveNeuronIndex');
