addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [1, 3, 4, 2, 5];

for nSession = 1:numSession
    load(['mat_results/run00' num2str(nSession) '/gpfa_xDim0' num2str(xDimSet(nSession)) '.mat'])
    gpfaEngine(seqTrain, seqTrain, ['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession)],... 
      'xDim', xDimSet(nSession), 'binWidth', 1, 'minVarFrac', -Inf);
end

close all