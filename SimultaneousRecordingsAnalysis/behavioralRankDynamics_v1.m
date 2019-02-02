addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_Simultaneous_Behaviors.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

var_beh  = nan(length(nDataSet), 3);

for nData = 1:length(nDataSet)
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
    
    early         = nBehaviors(nData).behavior_early_report;
    if iscolumn(early); early = early'; end
    ave_trial     = cumsum(early)./(1:length(early));
    early_trial   = ave_trial(trial_index);
    
    reward        = double(nBehaviors(nData).behavior_early_report==0 & nBehaviors(nData).behavior_report==1);
    if iscolumn(reward); reward = reward'; end
    ave_trial     = cumsum(reward)./(1:length(reward));
    reward_trial  = ave_trial(trial_index);
    
    if size(nBehaviors(nData).task_stimulation, 1)>1
        stim      = double(~(nBehaviors(nData).task_stimulation(:,1)==0));
    else
        stim      = double(~(nBehaviors(nData).task_stimulation==0));
    end
    if iscolumn(stim); stim = stim'; end
    ave_trial     = cumsum(stim)./(1:length(stim));
    stim_trial    = ave_trial(trial_index);
    
    var_beh(nData, 1) = std(early_trial);
    var_beh(nData, 2) = std(reward_trial);
    var_beh(nData, 3) = std(stim_trial);
    
end

figure
hist(var_beh*100)
xlabel('Std. behavioral variability (%)')
ylabel('# sessions')
box off
set(gca, 'TickDir', 'out')
legend('% early lick', '% reward', '% photostimulation')
setPrint(8, 6, 'Plots/Behavioral_variability', 'pdf')