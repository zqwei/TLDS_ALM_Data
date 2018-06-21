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
    
    if iscolumn(nDataSet(nData).unit_yes_trial_index)
        trial_index   = [nDataSet(nData).unit_yes_trial_index; nDataSet(nData).unit_no_trial_index];
    else
        trial_index   = [nDataSet(nData).unit_yes_trial_index, nDataSet(nData).unit_no_trial_index];
    end
    
%     early_trial   = nan(numTrials);
%     reward_trial  = nan(numTrials);
%     stim_trial    = nan(numTrials);
    
%     wind          = 3;
%     ave_trial_ = movmean(nBehaviors(nData).behavior_early_report, wind*2+1);
%     ave_trial  = nBehaviors(nData).behavior_early_report;
%     ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    early         = nBehaviors(nData).behavior_early_report;
    if iscolumn(early); early = early'; end
    ave_trial     = cumsum(early)./(1:length(early));
    early_trial   = ave_trial(trial_index);
    
    reward        = double(nBehaviors(nData).behavior_early_report==0 & nBehaviors(nData).behavior_report==1);
%     ave_trial_    = movmean(reward, wind*2+1);
%     ave_trial     = reward;
%     ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    if iscolumn(reward); reward = reward'; end
    ave_trial     = cumsum(reward)./(1:length(reward));
    reward_trial  = ave_trial(trial_index);
    
    if size(nBehaviors(nData).task_stimulation, 1)>1
        stim      = double(~nBehaviors(nData).task_stimulation(:,1)==0);
    else
        stim      = double(~nBehaviors(nData).task_stimulation==0);
    end
%     ave_trial_    = movmean(stim, wind*2+1);
%     ave_trial     = stim;
%     ave_trial(wind+1:end) = ave_trial_(1:end-wind);
    if iscolumn(stim); stim = stim'; end
    ave_trial     = cumsum(stim)./(1:length(stim));
    stim_trial    = ave_trial(trial_index);
    
    % KF
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
%     nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
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
    epochList        = {'presample', 'sample', 'delay', 'response'};
    
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        subplot(4, 3, (nEpoch-1)*3 + 1)
        scatter(early_trial*100, scoreMat_, [], group)
        xlabel('% previous early trials')
        ylabel('Neural dynamics')
        title(epochList{nEpoch})
        colormap(jet)
        subplot(4, 3, (nEpoch-1)*3 + 2)
        scatter(reward_trial*100, scoreMat_, [], group)
        xlabel('% previous reward trials')
        ylabel('Neural dynamics')
        title(epochList{nEpoch})
        subplot(4, 3, (nEpoch-1)*3 + 3)
        scatter(stim_trial*100, scoreMat_, [], group)
        xlabel('% previous photostimulated trials')
        ylabel('Neural dynamics')
        title(epochList{nEpoch})
    end
    
    setPrint(8*3, 6*4, ['Plots/Long_behavior_rank_idx_' num2str(nData)], 'pdf')
end