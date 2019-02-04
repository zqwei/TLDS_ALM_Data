%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GPFA fits for simultaneous recording data
%
% 
% Of note: xDimSet is obtained from correct data using fitGPFAoptDim.m
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
load([TempDatDir 'SimultaneousError_Spikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [2, 4, 6, 2, 4, 3, 4, 1, 4, 4, 4, 5, 6, 5, 6, 5, 9, 2, 3, 2, 3, 3];


for nSession = 1:numSession
    load(['mat_results/run0' num2str(nSession, '%02d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'], 'estParams');  
    Y_shuffle  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    seqTest    = repmat(struct('y',1, 'T', 1), size(Y_shuffle, 1), 1);
    for nTrial = 1:size(Y_shuffle, 1)
        seqTest(nTrial).y = sqrt(squeeze(Y_shuffle(nTrial, : , :)));
        seqTest(nTrial).T = size(Y_shuffle,3);
    end
    [fitData, ~] = exactInferenceWithLL(seqTest, estParams);
    
    y_est = nan(size(Y_shuffle));
            
    for nTrial = 1:size(Y_shuffle, 1)
        y_est_nTrial = estParams.C*fitData(nTrial).xsm;
        y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
        y_est_nTrial (y_est_nTrial <0) = 0;
        y_est_nTrial = y_est_nTrial.^2;
        y_est(nTrial, :, :) = y_est_nTrial;
    end
    
    save(['GPFAFits/gpfa_optxDimErrFit_idx_' num2str(nSession) '.mat'], 'estParams', 'seqTest', 'y_est');
    
end
