addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_Simultaneous_Behaviors.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])


param               = params(nDataSet(1).task_type);
sigma               = 0.15 / param.binsize; % 300 ms
filterLength        = 11;
filterStep          = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse         = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse         = filterInUse / sum (filterInUse); 

ntrial              = 1;

for nData = 17%1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
    
    if iscolumn(nDataSet(nData).unit_yes_trial_index)
        trial_index   = [nDataSet(nData).unit_yes_trial_index', nDataSet(nData).unit_no_trial_index'];
    else
        trial_index   = [nDataSet(nData).unit_yes_trial_index, nDataSet(nData).unit_no_trial_index];
    end
    
    early_trial   = nBehaviors(nData).behavior_early_report(max(trial_index-ntrial, 1));
    reward        = nBehaviors(nData).behavior_early_report==0 & nBehaviors(nData).behavior_report==1;
    reward_trial  = reward(max(trial_index-ntrial, 1));
    if size(nBehaviors(nData).task_stimulation, 1)>1
        stim      = double(~(nBehaviors(nData).task_stimulation(:,1)==0));
    else
        stim      = double(~(nBehaviors(nData).task_stimulation==0));
    end
    stim_trial    = stim(max(trial_index-ntrial, 1));
    trial_type    = nBehaviors(nData).task_trial_type(max(trial_index-ntrial, 1))==1;
    
    valid_trial   = true(size(reward_trial));%reward_trial;
    trial_variable  = early_trial;
    
    % KF
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
%     nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate   = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));   
    figure;
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);    
    
    %Full space
    nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate   = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-k','linewid',1},0.5);
    gridxy ([param.polein, param.poleout, 0],[0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    set(gca, 'TickDir', 'out')
    
%     setPrint(8, 6, ['Plots/Previous_KF_early_idx_' num2str(nData)], 'pdf')
    

end