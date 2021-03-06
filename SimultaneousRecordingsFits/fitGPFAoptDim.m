%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GPFA fits for simultaneous recording data
% 
% Results will be stored in folder mat_results
%
%
% ==========================================
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 2019-02-04
%
%
%
addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
numSession   = length(nDataSet);

for nSession = 1:numSession
    load(['mat_results/run0' num2str(nSession, '%02d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'])
    gpfaEngine(seqTrain, seqTrain, ['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession)],... 
      'xDim', xDimSet(nSession), 'binWidth', 1, 'minVarFrac', -Inf);
end

close all