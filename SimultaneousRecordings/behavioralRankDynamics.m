addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_Simultaneous_Behaviors.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

for nData = 17 %1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
    
    trial_index   = [nDataSet(nData).unit_yes_trial_index, nDataSet(nData).unit_no_trial_index];
    
    early_trial   = nan(numTrials);
    reward_trial  = nan(numTrials);
    
    
    % KF
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    rankMat_      = nan(numTrials, 4);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKFCorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
%         trialKFCorrEpoch(1, nEpoch) = mean(corr(scoreMat_(1:numYesTrial, :), (1:numYesTrial)', 'type', 'spearman'));
%         trialKFCorrEpoch(2, nEpoch) = mean(corr(scoreMat_(1+numYesTrial:end,:), (1:(numTrials-numYesTrial))', 'type', 'spearman'));
    end

end