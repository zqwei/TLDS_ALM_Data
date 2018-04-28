addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

% %% Print adjacent trials in each sessions
% sum_pair = 0;
% for nData = 1:length(nDataSet)
%     disp('--------------------------------')
%     disp(['Session #' num2str(nData)])
%     diff_trial = diff(nDataSet(nData).unit_yes_trial_index);
%     diff_trial_yes = find(diff_trial == 1);
%     if size(diff_trial_yes, 1)>1; diff_trial_yes = diff_trial_yes'; end
%     for n_trial = diff_trial_yes
%         disp(['Yes trial pair: ' num2str(nDataSet(nData).unit_yes_trial_index(n_trial)) ' and ' num2str(nDataSet(nData).unit_yes_trial_index(n_trial+1))])
%         sum_pair = sum_pair + 1;
%     end
%     diff_trial = diff(nDataSet(nData).unit_no_trial_index);
%     diff_trial_no = find(diff_trial == 1);
%     if size(diff_trial_no, 1)>1; diff_trial_no = diff_trial_no'; end
%     for n_trial = diff_trial_no
%         disp(['No trial pair: ' num2str(nDataSet(nData).unit_no_trial_index(n_trial)) ' and ' num2str(nDataSet(nData).unit_no_trial_index(n_trial+1))])
%         sum_pair = sum_pair + 1;
%     end
% end


pair_correlation = nan(50, 5, 4);
% 2nd dim
% col 1: pair correlation
% col 2: control pair correlation
% col 3: p-value
% col 4: session index
% col 5: yes/no

% 3rd dim
% epochs
tot_pair  = 0;
for nData = 1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
%     nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialCorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    
    % yes trials
    diff_trial     = diff(nDataSet(nData).unit_yes_trial_index);
    diff_trial_yes = find(diff_trial == 1);    
    if length(diff_trial_yes) > 1
        if size(diff_trial_yes, 1)>1
            diff_trial_yes = diff_trial_yes';
        end
        for n_trial  = diff_trial_yes
            tot_pair = tot_pair + 1;
            pair_correlation(tot_pair, 4, :) = nData;
            pair_correlation(tot_pair, 5, :) = 1;
            for nEpoch            = 1:length(timePoint)-1
                pair_corr         = trialCorrEpoch(n_trial, n_trial+1, nEpoch);
                control_pair_corr = trialCorrEpoch(n_trial:n_trial+1, 1:numYesTrial, nEpoch);
                control_pair_corr(:, n_trial:n_trial+1, :) = nan;
                control_pair_corr = control_pair_corr(:);
                control_pair_corr(isnan(control_pair_corr)) = [];
                pair_correlation(tot_pair, 1, nEpoch) = pair_corr;
                pair_correlation(tot_pair, 2, nEpoch) = median(control_pair_corr);
                pair_correlation(tot_pair, 3, nEpoch) = signrank(control_pair_corr, pair_corr);
            end
        end
    end
    
    % no trials 
    diff_trial = diff(nDataSet(nData).unit_no_trial_index);
    diff_trial_no = find(diff_trial == 1);
    if length(diff_trial_no) > 1
        if size(diff_trial_no, 1)>1; diff_trial_no = diff_trial_no'; end
        for n_trial = diff_trial_no
            tot_pair = tot_pair + 1;
            pair_correlation(tot_pair, 4, :) = nData;
            pair_correlation(tot_pair, 5, :) = 0;
            for nEpoch            = 1:length(timePoint)-1
                pair_corr         = trialCorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                control_pair_corr = trialCorrEpoch(n_trial+numYesTrial:n_trial+1+numYesTrial, 1+numYesTrial:end, nEpoch);
                if ~ismatrix(control_pair_corr); keyboard();end
                control_pair_corr(:, n_trial:n_trial+1, :) = nan;
                control_pair_corr = control_pair_corr(:);
                control_pair_corr(isnan(control_pair_corr)) = [];
                pair_correlation(tot_pair, 1, nEpoch) = pair_corr;
                pair_correlation(tot_pair, 2, nEpoch) = median(control_pair_corr);
                pair_correlation(tot_pair, 3, nEpoch) = signrank(control_pair_corr, pair_corr);
            end
        end
    end
end

figure;
epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
for nEpoch = 1:4
    subplot(1, 4, nEpoch)
    hold on
    plot(squeeze(pair_correlation(:,1,nEpoch)), squeeze(pair_correlation(:,2,nEpoch)), '.k')
    p = signrank(squeeze(pair_correlation(:,1,nEpoch)), squeeze(pair_correlation(:,2,nEpoch)), 'tail', 'right');
%     median(squeeze(pair_correlation(:,1,nEpoch))-squeeze(pair_correlation(:,2,nEpoch)))
    plot([0 1], [0, 1], '--k')
    xlim([0 1])
    xlabel('adjecent pair')
    ylabel('other pairs')
    title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
    set(gca, 'TickDir', 'out')
end

setPrint(8*4, 6, 'Plots/NPair_comparison')

% % figure
% % epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
% % for nEpoch = 1:4
% %     subplot(2, 2, nEpoch)
% %     hold on
% %     ksdensity(squeeze(pair_correlation(:,2,nEpoch)))
% %     ksdensity(squeeze(pair_correlation(:,1,nEpoch)))
% %     xlim([0 1])
% %     ylabel('PDF')
% %     xlabel('Trial rank correlation')
% %     title([epoch_titles{nEpoch} 'Epoch'])
% % end