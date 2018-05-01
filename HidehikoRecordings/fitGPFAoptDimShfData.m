addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [1, 3, 4, 2, 5, 8, 6, 4, 6, 6, 8, 8, 6, 6, 10, 6, 6, 4];
numShfTrials = 200;


for nSession = 1:numSession
    load(['/Volumes/My Drive/ALM_Recording_Pole_Task_Svoboda_Lab/TLDS_analysis_Li_data/GPFA_Hidehiko_Data/mat_results/run0' num2str(nSession, '%02d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'], 'estParams');
    Y_shuffle  = shuffleSession(nDataSet(nSession), numShfTrials);
    seqTest    = repmat(struct('y',1, 'T', 1),numShfTrials*2, 1);
    for nTrial = 1:numShfTrials*2
        seqTest(nTrial).y = sqrt(squeeze(Y_shuffle(nTrial, : , :)));
        seqTest(nTrial).T = size(Y_shuffle,3);
    end
    [fitData, ~] = exactInferenceWithLL(seqTest, estParams);
    
    y_est = nan(size(Y_shuffle));
            
    for nTrial = 1:size(Y_shuffle, 1)
        y_est_nTrial = estParams.C*fitData(nTrial).xsm;
%         y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
%         y_est_nTrial (y_est_nTrial <0) = 0;
%         y_est_nTrial = y_est_nTrial.^2;
        y_est(nTrial, :, :) = y_est_nTrial;
    end
    
    save(['GPFAFits/gpfa_optxDimShfFit_idx_' num2str(nSession) '.mat'], 'estParams', 'seqTest', 'y_est');
    
end

close all