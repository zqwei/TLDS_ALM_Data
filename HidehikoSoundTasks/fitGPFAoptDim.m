addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
numSession   = length(nDataSet);
sessInd      = [ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16];
xDimSet      = [ 9, 6, 5, 6, 7, 7, 9, 7, 5, 8,15, 7,10, 8, 7,10];

for nSession = 1:numSession
    load(['mat_results/run' num2str(nSession, '%03d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'])
    gpfaEngine(seqTrain, seqTrain, ['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession)],... 
      'xDim', xDimSet(nSession), 'binWidth', 1, 'minVarFrac', -Inf);
end

close all