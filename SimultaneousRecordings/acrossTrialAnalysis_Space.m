 addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

pair_correlation = nan(50, 10, 4);
% 2nd dim
% col 1: KF pair correlation
% col 2: Full space
% col 3: CKF
% col 4: GPFA
% col 5: yes/no
% col 6: session index
% col 7: KF forward
% col 8: KS2
% col 9: KS4
% col 10: KS8

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
    
    % KF
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKFCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialKFCorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %Full space
    nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialFullCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialFullCorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %CKF
    nSessionData  = [nDataSet(nData).unit_CKF_yes_fit; nDataSet(nData).unit_CKF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialCKFCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialCKFCorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %GPFA
    nSessionData  = [nDataSet(nData).unit_GPFA_yes_fit; nDataSet(nData).unit_GPFA_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialGPFACorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialGPFACorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %KF forward
    nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKFForwardCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialKFForwardCorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %KS2
    nSessionData  = fitData(nData).K2yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKS2CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialKS2CorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %KS4
    nSessionData  = fitData(nData).K4yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKS4CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialKS4CorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
    end
    
    %KS8
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKS8CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1));
        trialKS8CorrEpoch(:, :, nEpoch) = abs(corr(scoreMat_', 'type', 'spearman'));
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
            pair_correlation(tot_pair, 6, :) = nData;
            pair_correlation(tot_pair, 5, :) = 1;
            for nEpoch            = 1:length(timePoint)-1
                pair_correlation(tot_pair, 1, nEpoch) = trialKFCorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 2, nEpoch) = trialFullCorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 3, nEpoch) = trialCKFCorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 4, nEpoch) = trialGPFACorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 7, nEpoch) = trialKFForwardCorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 8, nEpoch) = trialKS2CorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair, 9, nEpoch) = trialKS4CorrEpoch(n_trial, n_trial+1, nEpoch);
                pair_correlation(tot_pair,10, nEpoch) = trialKS8CorrEpoch(n_trial, n_trial+1, nEpoch);
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
            pair_correlation(tot_pair, 6, :) = nData;
            pair_correlation(tot_pair, 5, :) = 0;
            for nEpoch            = 1:length(timePoint)-1
                pair_correlation(tot_pair, 1, nEpoch) = trialKFCorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 2, nEpoch) = trialFullCorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 3, nEpoch) = trialCKFCorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 4, nEpoch) = trialGPFACorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 7, nEpoch) = trialKFForwardCorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 8, nEpoch) = trialKS2CorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair, 9, nEpoch) = trialKS4CorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
                pair_correlation(tot_pair,10, nEpoch) = trialKS8CorrEpoch(n_trial+numYesTrial, n_trial+1+numYesTrial, nEpoch);
            end
        end
    end
end

figure;
epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
% xlabels = {'Full space', 'LDS', 'GPFA'};
tot_plot = 0;
for nPlot = [1 2 3 6 7 8 9]
    for nEpoch = 1:4
        tot_plot = tot_plot + 1;
        subplot(7, 4, tot_plot)
        hold on
        plot(squeeze(pair_correlation(:,1,nEpoch)), squeeze(pair_correlation(:,nPlot+1,nEpoch)), '.k')
        p = signrank(squeeze(pair_correlation(:,nPlot+1,nEpoch)), squeeze(pair_correlation(:,1,nEpoch)), 'tail', 'left');
%         median(squeeze(pair_correlation(:,1,nEpoch))-squeeze(pair_correlation(:,nPlot+1,nEpoch)))
        plot([0 1], [0, 1], '--k')
        xlim([0 1])
        ylabel('SAS')
        xlabel('Neural space')
        title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
        set(gca, 'TickDir', 'out')
    end
end
setPrint(8*4, 6*7, 'Plots/NPair_comparison_Fits')

% figure
% epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
% for nEpoch = 1:4
%     subplot(2, 2, nEpoch)
%     hold on
%     ksdensity(squeeze(pair_correlation(:,2,nEpoch)))
%     ksdensity(squeeze(pair_correlation(:,1,nEpoch)))
%     xlim([0 1])
%     ylabel('PDF')
%     xlabel('Trial rank correlation')
%     title([epoch_titles{nEpoch} 'Epoch'])
% end