addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])

session_pair_corrlation = nan(length(nDataSet), 8, 4, 2);
% 2nd dim
% col 1: KF pair correlation
% col 2: Full space
% col 3: CKF
% col 4: GPFA
% col 5: KF forward
% col 6: KS2
% col 7: KS4
% col 8: KS8

% 3rd dim
% epochs
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
    rankMat       = nan(numTrials, 1);
    rankMat_      = nan(numTrials, 4);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKFCorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialKFCorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialKFCorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end

    
    
    %Full space
    nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    rankMat_      = nan(numTrials, 4);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialFullCorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialFullCorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialFullCorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
            
    %CKF
    nSessionData  = [nDataSet(nData).unit_CKF_yes_fit; nDataSet(nData).unit_CKF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialCKFCorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialCKFCorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialCKFCorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
    
    %GPFA
    nSessionData  = [nDataSet(nData).unit_GPFA_yes_fit; nDataSet(nData).unit_GPFA_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialGPFACorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialGPFACorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialGPFACorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
    
    %KF forward
    nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    trialKFForwardCorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialKFForwardCorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialKFForwardCorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
    
    %KS2
    nSessionData  = fitData(nData).K2yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    trialKS2CorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialKS2CorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialKS2CorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
    
    %KS4
    nSessionData  = fitData(nData).K4yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    
    trialKS4CorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialKS4CorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialKS4CorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end
    
    %KS8
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    rankMat       = nan(numTrials, 1);
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    
    trialKS8CorrEpoch = nan(2, length(timePoint)-1);
    for nEpoch     = 1:length(timePoint)-1
        scoreMat_  = mean(scoreMat(:, timePoint(nEpoch):timePoint(nEpoch+1)), 2);
        [~, rankMat(1:numYesTrial)] = sort(scoreMat_(1:numYesTrial),'ascend');
        rankMat(1:numYesTrial) = rankMat(1:numYesTrial)/max(rankMat(1:numYesTrial));
        [~, rankMat(1+numYesTrial:end)] = sort(scoreMat_(1+numYesTrial:end),'ascend');
        rankMat(1+numYesTrial:end) = rankMat(1+numYesTrial:end)/max(rankMat(1+numYesTrial:end));
        trialKS8CorrEpoch(1, nEpoch) = corr(rankMat(1:numYesTrial), (1:numYesTrial)', 'type', 'spearman');
        trialKS8CorrEpoch(2, nEpoch) = corr(rankMat(1+numYesTrial:end), (1:(numTrials-numYesTrial))', 'type', 'spearman');
    end


    for nEpoch            = 1:length(timePoint)-1
        session_pair_corrlation(nData, 1, nEpoch, 1) = trialKFCorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 2, nEpoch, 1) = trialFullCorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 3, nEpoch, 1) = trialCKFCorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 4, nEpoch, 1) = trialGPFACorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 5, nEpoch, 1) = trialKFForwardCorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 6, nEpoch, 1) = trialKS2CorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 7, nEpoch, 1) = trialKS4CorrEpoch(1, nEpoch);
        session_pair_corrlation(nData, 8, nEpoch, 1) = trialKS8CorrEpoch(1, nEpoch);

        session_pair_corrlation(nData, 1, nEpoch, 2) = trialKFCorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 2, nEpoch, 2) = trialFullCorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 3, nEpoch, 2) = trialCKFCorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 4, nEpoch, 2) = trialGPFACorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 5, nEpoch, 2) = trialKFForwardCorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 6, nEpoch, 2) = trialKS2CorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 7, nEpoch, 2) = trialKS4CorrEpoch(2, nEpoch);
        session_pair_corrlation(nData, 8, nEpoch, 2) = trialKS8CorrEpoch(2, nEpoch);
    end

end

session_pair_corrlation = abs(session_pair_corrlation);

figure;
epoch_titles = {'PreSample', 'Sample', 'Delay', 'Response'};
xlabels = {'Full space', 'LDS', 'GPFA',  'KF forward', 'sLDS2', 'sLDS4', 'sLDS8'};
tot_plot = 0;
for nPlot = 1:7
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
        xlim([0 1])
        ylim([0 1])
        ylabel('SAS')
        xlabel(xlabels{nPlot})
        title([epoch_titles{nEpoch} 'p=' num2str(p, '%.3f')])
        set(gca, 'TickDir', 'out')
    end
end
setPrint(8*4, 6*7, 'Plots/NSession_comparison_Fits', 'pdf')