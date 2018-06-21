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
    
%     early_trial   = nan(numTrials);
%     reward_trial  = nan(numTrials);
%     stim_trial    = nan(numTrials);
    
    wind          = 3;
    ave_trial_ = movmean(nBehaviors(nData).behavior_early_report, wind*2+1);
    ave_trial  = nBehaviors(nData).behavior_early_report;
    ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    early_trial   = ave_trial(trial_index);
    
    reward        = double(nBehaviors(nData).behavior_early_report==0 & nBehaviors(nData).behavior_report==1);
    ave_trial_    = movmean(reward, wind*2+1);
    ave_trial     = reward;
    ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    reward_trial  = ave_trial(trial_index);
    
    if size(nBehaviors(nData).task_stimulation, 1)>1
        stim      = double(~nBehaviors(nData).task_stimulation(:,1)==0);
    else
        stim      = double(~nBehaviors(nData).task_stimulation==0);
    end
    ave_trial_    = movmean(stim, wind*2+1);
    ave_trial     = stim;
    ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    stim_trial    = ave_trial(trial_index);
    
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
    
    figure
    trialKFCorrEpoch = nan(2, length(timePoint)-1);
    group            = [ones(numYesTrial, 1); ones(numTrials-numYesTrial, 1)*2];
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        scoreMat_  
        subplot(2, 2, 1)
        imagesc(corr(scoreMat_(1:numYesTrial, :), reward_trial(1:numYesTrial, :), 'type', 'spearman'))
        subplot(2, 2, 2)
        imagesc(corr(scoreMat_(1+numYesTrial:end, :)', 'type', 'spearman'))
        subplot(2, 2, 3)
        imagesc(corr(, 'type', 'spearman'))
        subplot(2, 2, 4)
        imagesc(corr(reward_trial(1+numYesTrial:end, :)', 'type', 'spearman'))
    end

end