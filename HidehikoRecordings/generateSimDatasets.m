%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate data from shuffled dataset code (based on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

% Rename the DataSetList Names as the simultaneously recorded datasets
minUnitsSession        = 6;
minRate                = 0;
perMinRate             = 0.4; % percentage of min Rate in an entire trial
ROCThres               = 0.50;
minTrialRatio          = 2.0;

load([TempDatDir 'Shuffle_HiSpikes.mat']);
params.ROCIndex          = ROCPop(nDataSet, params);
params.ActiveNeuronIndex = true(length(nDataSet), 1);%ActiveNeuronIndex;
[nDataSet, kickOutIndex] = ...
                        getSimultaneousSpikeData(nDataSet, ...
                        params,...
                        minRate, perMinRate, ROCThres, ...
                        minUnitsSession);
nDataSet = nDataSet([8:12, 2:7]);
save([TempDatDir 'Simultaneous_HiSpikes.mat'], 'nDataSet', 'kickOutIndex', 'params', 'ActiveNeuronIndex');
