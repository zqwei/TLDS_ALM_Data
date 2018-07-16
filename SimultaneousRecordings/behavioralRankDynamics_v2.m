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

ave_reward          =  nan(length(nDataSet), 8);

ntrial              = 1;

for nData = 1:length(nDataSet)
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
    
    early_lick    = nBehaviors(nData).behavior_early_report(max(trial_index-ntrial, 1));
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
    trial_variable  = reward_trial;
    
    if sum(trial_variable(valid_trial)==0)<13 || sum(trial_variable(valid_trial)==1)<13 
        continue;
    end
        
    
    % KF
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate   = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));    
    ave_reward(nData, 1) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %Full space
    nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 2) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    
    %CKF
    nSessionData  = [nDataSet(nData).unit_CKF_yes_fit; nDataSet(nData).unit_CKF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 3) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %GPFA
    nSessionData  = [nDataSet(nData).unit_GPFA_yes_fit; nDataSet(nData).unit_GPFA_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 4) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %KF forward
    nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 5) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %KS2
    nSessionData  = fitData(nData).K2yEst;
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 6) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %KS4
    nSessionData  = fitData(nData).K4yEst;
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 7) = mean(correctRate(1, timePoint(1):timePoint(2)));
    
    %KS8
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2); 
    correctRate = coeffSVM(nSessionData(valid_trial,:, :), trial_variable(valid_trial));
    ave_reward(nData, 8) = mean(correctRate(1, timePoint(1):timePoint(2)));     

end

% save('ave_reward.mat', 'ave_reward')
% 
% load('ave_reward.mat')

figure;
xlabels = {'Full space', 'LDS', 'GPFA',  'KF forward', 'sLDS2', 'sLDS4', 'sLDS8'};
tot_plot = 0;
for nPlot = 1:7
    tot_plot = tot_plot + 1;
    subplot(1, 7, tot_plot)
    hold on
    plot(ave_reward(:, nPlot+1), ave_reward(:, 5), 'ob')
    p = signrank(ave_reward(:, 5), ave_reward(:, nPlot+1), 'tail', 'both')
    plot([0 1], [0, 1], '--k')
%     xlim([0 0.6])
%     ylim([0 0.6])
    xlabel('SAS')
    ylabel(xlabels{nPlot})
%     if p > 0.001
%         disp([epoch_titles{nEpoch} ' ' xlabels{nPlot} ' ' num2str(p)])
%     end
%         title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
    set(gca, 'TickDir', 'out')
end

setPrint(8*7, 6, 'Plots/NSession_comparison_previous_1_trial_Fits', 'pdf')
% setPrint(8*7, 6, 'Plots/NSession_comparison_previous_2_trial_early_lick_Fits', 'pdf')
% setPrint(8*7, 6, 'Plots/NSession_comparison_previous_trial_choice_Fits', 'pdf')