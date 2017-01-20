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

load([TempDatDir 'Simultaneous_Spikes.mat'])
refDataSet = nDataSet;

load([TempDatDir 'DataListEphys.mat']);

for nData                = 1:length(DataSetList)
    load([TempDatDir DataSetList(nData).name '.mat'])
    params                   = DataSetList(nData).params;
    params.ROCIndex          = ROCPop(nDataSet, params);
    ActiveNeuronIndex        = DataSetList(nData).ActiveNeuronIndex;
    params.ActiveNeuronIndex = ActiveNeuronIndex;
    nDataSet                 = getSimultaneousSpikeDataFromRef(nDataSet, refDataSet);
    save([TempDatDir 'Simultaneous' DataSetList(nData).name(8:end) '.mat'], 'nDataSet', 'kickOutIndex', 'params', 'ActiveNeuronIndex');
    DataSetList(nData).name    = ['Simultaneous' DataSetList(nData).name(8:end)];
end


save([TempDatDir 'DataListSimEphys.mat'], 'DataSetList');