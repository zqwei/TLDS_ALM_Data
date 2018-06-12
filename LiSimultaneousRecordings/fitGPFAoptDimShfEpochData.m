addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
numSession   = length(nDataSet);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
T            = length(params.timeSeries);
timePoint    = timePoint(2:end-1);
xDimSet      = [2, 4, 6, 2, 4, 3, 4, 1, 4, 4, 4, 5, 6, 5, 6, 5, 9, 2, 3, 2, 3, 3];
numShfTrials = 200;

folderDir    = '/Volumes/weiz/TLDS/LiSimultaneousRecordings/';

for nSession = 1:numSession
    load([folderDir 'mat_results/run0' num2str(nSession, '%02d') '/gpfa_xDim' num2str(xDimSet(nSession), '%02d') '.mat'], 'estParams');
    Y_shuffle  = shuffleSessionEpoch(nDataSet(nSession), numShfTrials, [0, timePoint, T]);
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
    
    save(['GPFAFits/gpfa_optxDimShfEpochFit_idx_' num2str(nSession) '.mat'], 'estParams', 'seqTest', 'y_est');
    
end

close all