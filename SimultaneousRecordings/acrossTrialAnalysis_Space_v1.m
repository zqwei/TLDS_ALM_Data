addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

pair_correlation = nan(50, 12, 4);
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
% col 11: nSession
% col 12: yes/no

% 3rd dim
% epochs
tot_pair  = 0;
for nData = 17%1:length(nDataSet)
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
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end
    
    trialKFCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        % scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialKFCorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %Full space
    nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialFullCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialFullCorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %CKF
    nSessionData  = [nDataSet(nData).unit_CKF_yes_fit; nDataSet(nData).unit_CKF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialCKFCorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialCKFCorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %GPFA
    nSessionData  = [nDataSet(nData).unit_GPFA_yes_fit; nDataSet(nData).unit_GPFA_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialGPFACorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialGPFACorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
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
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialKFForwardCorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %KS2
    nSessionData  = fitData(nData).K2yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialKS2CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialKS2CorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %KS4
    nSessionData  = fitData(nData).K4yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialKS4CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialKS4CorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    %KS8
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
        rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/max(rankMat(1:numYesTrial, nTime));
        [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
        rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/max(rankMat(1+numYesTrial:end, nTime));
    end

    
    trialKS8CorrEpoch = nan(numTrials, numTrials, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(rankMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        trialKS8CorrEpoch(:, :, nEpoch) = 1-abs(scoreMat_ - scoreMat_');
    end
    
    % yes trials
    diff_trial     = diff(nDataSet(nData).unit_yes_trial_index);
    diff_trial_yes = find(diff_trial == 1);
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
            pair_correlation(tot_pair, 5, :) = 2;
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


session_pair_corrlation = nan(length(nDataSet), 10, 4, 2);

for nData = 1:length(nDataSet)
    for ntrial = 1:2
        session_pair_corrlation(nData, :, :, ntrial) = mean(pair_correlation(pair_correlation(:, 6)==nData & pair_correlation(:, 5)==ntrial, 1:10, :));
    end
end

% figure;
% epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
% % xlabels = {'Full space', 'LDS', 'GPFA'};
% tot_plot = 0;
% for nPlot = [1 2 3 6 7 8 9]
%     for nEpoch = 1:4
%         tot_plot = tot_plot + 1;
%         subplot(7, 4, tot_plot)
%         hold on
%         plot(squeeze(pair_correlation(:,1,nEpoch)), squeeze(pair_correlation(:,nPlot+1,nEpoch)), '.k')
%         p = signrank(squeeze(pair_correlation(:,nPlot+1,nEpoch)), squeeze(pair_correlation(:,1,nEpoch)), 'tail', 'left');
% %         median(squeeze(pair_correlation(:,1,nEpoch))-squeeze(pair_correlation(:,nPlot+1,nEpoch)))
%         plot([0 1], [0, 1], '--k')
%         xlim([0 1])
%         ylabel('SAS')
%         xlabel('Neural space')
%         title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
%         set(gca, 'TickDir', 'out')
%     end
% end
% setPrint(8*4, 6*7, 'Plots/NPair_comparison_Fits')

figure;
epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
xlabels = {'Full space', 'LDS', 'GPFA', '', '',  'KF forward', 'sLDS2', 'sLDS4', 'sLDS8'};
tot_plot = 0;
for nPlot = [1 2 3 6 7 8 9]
    for nEpoch = 1:4
        tot_plot = tot_plot + 1;
        subplot(7, 4, tot_plot)
        hold on
        plot(squeeze(session_pair_corrlation(:,1,nEpoch, 1)), squeeze(session_pair_corrlation(:,nPlot+1,nEpoch, 1)), '.b')
        plot(squeeze(session_pair_corrlation(:,1,nEpoch, 2)), squeeze(session_pair_corrlation(:,nPlot+1,nEpoch, 2)), '.r')
        vec1 = squeeze(session_pair_corrlation(:,nPlot+1,nEpoch, :));
        vec2 = squeeze(session_pair_corrlation(:,1,nEpoch, :));
        p = signrank(vec1(:), vec2(:), 'tail', 'both');
        plot([0 1], [0, 1], '--k')
        xlim([0.7 1])
        ylim([0.7 1])
        ylabel('SAS')
        xlabel(xlabels{nPlot})
        title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
        set(gca, 'TickDir', 'out')
    end
end
setPrint(8*4, 6*7, 'Plots/NPair_comparison_Fits', 'pdf')