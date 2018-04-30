addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;
load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
% nDataSet(12) = [];
numSession   = length(nDataSet);
xDimSet      = [ 5, 6, 4, 6, 4, 6, 4, 6, 3, 8, 8, 0, 8, 6, 6, 7];
optFitSet    = [12,13,28,2,25,12,27,26,3,2,3,NaN,20,17,7,25];
params.timeSeries = params.timeSeries(params.timeSeries<1.5);
T            = length(params.timeSeries);
timePoints   = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoints(2:end-1);
nFold        = 30;


% col #1: sample-sample
% col #2: delay-delay
% col #3: response-response
% col #4: sample-delay
% col #5: delay-response

% row #1: all
% row #2: contra
% row #3: ipsi

GPFAMean     = nan(numSession, 3, 7);
GPFAStd      = nan(numSession, 3, 7);

TLDSMean     = nan(numSession, 3, 7);
TLDSStd      = nan(numSession, 3, 7);

for nSession = [1 2 3 4 5 6 7 8 9 10 11 13 14 15 16]    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Ts         = size(Y, 3);
    Y          = Y(:, :, 1:T);
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    
    m          = ceil(yDim/4)*2;
    
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = nSessionData(:, :, 1:T);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatSpike = scoreMat;
    
    load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
    y_est = nan(size(Y,1), Ts, size(Y, 3));
    for nTrial = 1:size(Y, 3)
        y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
        y_est(:, :, nTrial) = y_est_nTrial;
    end
    
    y_est         = y_est(:, 1:T, :);
    
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2); 
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatGPFA  = scoreMat;
    xDim       = xDimSet(nSession);
    for n_fold = 1:nFold
        load ([TempDatDir 'SessionHiSound_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(n_fold) '.mat'],'Ph');
        [curr_err(n_fold),~] = loo (Y, Ph, [0, timePoint, T]);
    end
    [~, optFit] = min(curr_err);
    load ([TempDatDir 'SessionHiSound_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatTLDS  = scoreMat;    
    
    [GPFAMean(nSession,:,:), GPFAStd(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatGPFA, scoreMatSpike, timePoints, totTargets);
    [TLDSMean(nSession,:,:), TLDSStd(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatTLDS, scoreMatSpike, timePoints, totTargets);
end
GPFAMean(12,:,:) = [];
GPFAStd(12,:,:) = [];
TLDSMean(12,:,:) = [];
TLDSStd(12,:,:) = [];

% Boxcar150Mean     = nan(numSession, 3, 7);
% Boxcar150Std      = nan(numSession, 3, 7);
% 
% Boxcar250Mean     = nan(numSession, 3, 7);
% Boxcar250Std      = nan(numSession, 3, 7);
% 
% 
% load([TempDatDir 'DataListSimEphysHiSound.mat']);
% 
% for nSession  = [1 2 3 4 5 6 7 8 9 10 11 13 14 15 16]
%     nData         = 2;
%     load([TempDatDir DataSetList(nData).name '.mat'])
%     numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
%     numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
%     numTrials   = numYesTrial + numNoTrial;
%     params.timeSeries = params.timeSeries(params.timeSeries<1.5);
%     Tmm           = length(params.timeSeries);
%     timePoints    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);    
%     totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
%     numUnits      = length(nDataSet(nSession).nUnit);
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = nSessionData(:, :, 1:Tmm);
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = coeffLDA(nSessionData, totTargets);
%     scoreMat      = nan(numTrials, size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%     end
%     
%     scoreMatBox70 = scoreMat;
%     
%     nData         = 4;
%     load([TempDatDir DataSetList(nData).name '.mat'])
%     params.timeSeries = params.timeSeries(params.timeSeries<1.5);
%     Tmm           = length(params.timeSeries);
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = nSessionData(:, :, 1:Tmm);
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = coeffLDA(nSessionData, totTargets);
%     scoreMat      = nan(numTrials, size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%     end
%     
%     scoreMatBox150= scoreMat;
%     
%     nData         = 6;
%     load([TempDatDir DataSetList(nData).name '.mat'])
%     params.timeSeries = params.timeSeries(params.timeSeries<1.5);
%     Tmm           = length(params.timeSeries);
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = nSessionData(:, :, 1:Tmm);
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = coeffLDA(nSessionData, totTargets);
%     scoreMat      = nan(numTrials, size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%     end
%     
%     scoreMatBox250= scoreMat;
%     
%     [Boxcar150Mean(nSession,:,:), Boxcar150Std(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatBox150, scoreMatBox70, timePoints, totTargets);
%     [Boxcar250Mean(nSession,:,:), Boxcar250Std(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatBox250, scoreMatBox70, timePoints, totTargets);
%     
% end

save([TempDatDir 'SimilarityHiSoundIndex.mat'], 'GPFAMean', 'GPFAStd', 'TLDSMean', 'TLDSStd')
save([TempDatDir 'SimilarityHiSoundIndex.mat'], 'Boxcar150Mean', 'Boxcar150Std', 'Boxcar250Mean', 'Boxcar250Std' , '-append')