addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3];
optFitSets   = [4, 25, 7, 20, 8];
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

GPFAMean     = nan(numSession, 3, 5);
GPFAStd      = nan(numSession, 3, 5);

TLDSMean     = nan(numSession, 3, 5);
TLDSStd      = nan(numSession, 3, 5);

for nSession = 1:numSession    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    m          = ceil(yDim/4)*2;
    
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatSpike = scoreMat;
    
    load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
    y_est = nan(size(Y));
    for nTrial = 1:size(Y, 3)
        y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
%                 y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
%                 y_est_nTrial (y_est_nTrial <0) = 0;
%                 y_est_nTrial = y_est_nTrial.^2;
        y_est(:, :, nTrial) = y_est_nTrial;
    end
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2); 
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatGPFA  = scoreMat;
    xDim       = xDimSet(nSession);
    optFit     = optFitSets(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
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


Boxcar150Mean     = nan(numSession, 3, 5);
Boxcar150Std      = nan(numSession, 3, 5);

Boxcar250Mean     = nan(numSession, 3, 5);
Boxcar250Std      = nan(numSession, 3, 5);


load([TempDatDir 'DataListSimEphysHi.mat']);

for nSession  = 1:numSession    
    nData         = 2;
    load([TempDatDir DataSetList(nData).name '.mat'])
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    timePoints    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);    
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatBox70 = scoreMat;
    
    nData         = 4;
    load([TempDatDir DataSetList(nData).name '.mat'])
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatBox150= scoreMat;
    
    nData         = 6;
    load([TempDatDir DataSetList(nData).name '.mat'])
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    scoreMatBox250= scoreMat;
    
    [Boxcar150Mean(nSession,:,:), Boxcar150Std(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatBox150, scoreMatBox70, timePoints, totTargets);
    [Boxcar250Mean(nSession,:,:), Boxcar250Std(nSession,:,:)] = computeSimilarityEpochTrialType(scoreMatBox250, scoreMatBox70, timePoints, totTargets);
    
end

save([TempDatDir 'SimilarityIndexHi.mat'], 'GPFAMean', 'GPFAStd', 'TLDSMean', 'TLDSStd')
save([TempDatDir 'SimilarityIndexHi.mat'], 'Boxcar150Mean', 'Boxcar150Std', 'Boxcar250Mean', 'Boxcar250Std' , '-append')