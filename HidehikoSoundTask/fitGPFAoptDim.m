addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [1, 3, 4, 2, 5, 8, 6, 4, 6, 6, 8, 8, 6, 6, 10, 6, 6, 4];

for nSession = 1:numSession
    load(['mat_results/run' num2str(nSession, '%03d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'])
    gpfaEngine(seqTrain, seqTrain, ['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession)],... 
      'xDim', xDimSet(nSession), 'binWidth', 1, 'minVarFrac', -Inf);
end

close all