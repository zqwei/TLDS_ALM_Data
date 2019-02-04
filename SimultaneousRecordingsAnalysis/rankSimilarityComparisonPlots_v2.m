%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% epoch based rank similarity comparison
% 
%
% ==========================================
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 2019-02-04
%
%
%
addpath('../Func');
setDir;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])


RefMean   = nan(length(nDataSet), 3, 3);
TLDSMean  = nan(length(nDataSet), 3, 3);

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

    corrMat       = abs(corr(scoreMat, 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        TLDSMean(nData, 1, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end

    corrMat       = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        TLDSMean(nData, 2, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end

    corrMat       = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        TLDSMean(nData, 3, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end

    % RF
    nSessionData  = [nDataSet(nData).unit_KFFoward_yes_fit; nDataSet(nData).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    corrMat       = abs(corr(scoreMat, 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        RefMean(nData, 1, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end

    corrMat       = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        RefMean(nData, 2, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end

    corrMat       = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'spearman'));
    
    for nEpoch     = 1:length(timePoint)-2
        RefMean(nData, 3, nEpoch) = mean(mean(corrMat(timePoint(nEpoch):timePoint(nEpoch+1),timePoint(nEpoch+1):timePoint(nEpoch+2))));
    end


end

figure;
titleSet  = {'All', 'Contra', 'Ipsi'};
for nPlot = 1:length(titleSet)
    subplot(1, 3, nPlot)
    hold on
    for nEpoch = 1:size(RefMean, 3)
        plot(squeeze(RefMean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), 'o')
    end
    plot([0 1], [0 1], '--k')
    box off
    xlim([0 0.6])
    ylim([0 0.6])
    xlabel('Other similarity index')
    ylabel('TLDS similarity index')
    title(titleSet{nPlot})
    set(gca, 'TickDir', 'out')
    
    Refs  = squeeze(RefMean(:, nPlot, :));
    TLDSs = squeeze(TLDSMean(:, nPlot, :));    
end

setPrint(8*3, 6, 'Plots/SimilarityIndex_other_TLDS')