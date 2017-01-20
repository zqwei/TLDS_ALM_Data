%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mRow = ceil(length(nDataSet)/mCol);
timePoints          = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
numEpochs           = 4;

% figure; 
% for nSession      = 1:length(nDataSet)
%     numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
%     numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
%     totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
%     numUnits      = length(nDataSet(nSession).nUnit);
%     numTrials     = numYesTrial + numNoTrial;
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = nan(size(nSessionData, 2), numEpochs);
%     for nPeriod       = 1:numEpochs
%         coeffs(:, nPeriod) = coeffTrialLDA(nSessionData(:, :, timePoints(nPeriod)+1:timePoints(nPeriod+1)), totTargets);
%     end
%     scoreMat      = nan(numTrials, size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         nEpoch    = sum(params.timeSeries(nTime)>[params.polein, params.poleout, 0])+1;
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nEpoch);
%     end     
%     subplot(mRow, mCol, nSession)
%     hold on
%     plot(params.timeSeries, scoreMat(1:8, :), '-b')
%     plot(params.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
%     gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
%     xlim([min(params.timeSeries) max(params.timeSeries)]);
%     box off
%     hold off
%     xlabel('Time (s)')
%     ylabel('LDA score')
%     title(['# units: ' num2str(numUnits)])
%     set(gca, 'TickDir', 'out')
% end 
% setPrint(8*mCol, 6*mRow, 'Plots/LDAscoreEpoch')


figure;
for nSession      = 1:length(nDataSet)
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    
    mean_yes     = mean(mean(nDataSet(nSession).unit_yes_trial(:, 1:8)));
    mean_no      = mean(mean(nDataSet(nSession).unit_no_trial(:, 1:8)));
    
    nSessionData  = [nDataSet(nSession).unit_yes_trial - mean_yes; nDataSet(nSession).unit_no_trial - mean_no];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = nan(size(nSessionData, 2), numEpochs);
    for nPeriod       = 1:numEpochs
        coeffs(:, nPeriod) = coeffTrialLDA(nSessionData(:, :, timePoints(nPeriod)+1:timePoints(nPeriod+1)), totTargets);
    end
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        nEpoch    = sum(params.timeSeries(nTime)>[params.polein, params.poleout, 0])+1;
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nEpoch);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(mRow, mCol, nSession)
    hold on
    imagesc(params.timeSeries, params.timeSeries, simCorrMat);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([min(params.timeSeries) max(params.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title(['# units: ' num2str(numUnits)])
    set(gca, 'TickDir', 'out')
end

setPrint(8*mCol, 6*mRow, 'Plots/SimilarityLDALDAscoreEpoch')



figure;
for nSession      = 1:length(nDataSet)
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = nan(size(nSessionData, 2), numEpochs);
    for nPeriod       = 1:numEpochs
        coeffs(:, nPeriod) = coeffTrialLDA(nSessionData(:, :, timePoints(nPeriod)+1:timePoints(nPeriod+1)), totTargets);
    end
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        nEpoch    = sum(params.timeSeries(nTime)>[params.polein, params.poleout, 0])+1;
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nEpoch);
    end    
    simCorrMat    = abs(corr(scoreMat(1:numYesTrial,:), 'type', 'Spearman'));
    subplot(mRow, mCol, nSession)
    hold on
    imagesc(params.timeSeries, params.timeSeries, simCorrMat);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([min(params.timeSeries) max(params.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title(['# units: ' num2str(numUnits)])
    set(gca, 'TickDir', 'out')
end

setPrint(8*mCol, 6*mRow, 'Plots/SimilarityContraLDALDAscoreEpoch')


figure;
for nSession      = 1:length(nDataSet)
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = nan(size(nSessionData, 2), numEpochs);
    for nPeriod       = 1:numEpochs
        coeffs(:, nPeriod) = coeffTrialLDA(nSessionData(:, :, timePoints(nPeriod)+1:timePoints(nPeriod+1)), totTargets);
    end
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        nEpoch    = sum(params.timeSeries(nTime)>[params.polein, params.poleout, 0])+1;
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nEpoch);
    end    
    simCorrMat    = abs(corr(scoreMat(1+numYesTrial:end,:), 'type', 'Spearman'));
    subplot(mRow, mCol, nSession)
    hold on
    imagesc(params.timeSeries, params.timeSeries, simCorrMat);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([min(params.timeSeries) max(params.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title(['# units: ' num2str(numUnits)])
    set(gca, 'TickDir', 'out')
end

setPrint(8*mCol, 6*mRow, 'Plots/SimilarityIpsiLDALDAscoreEpoch')

% setColorbar(cmap, 0, 1, 'similarity', 'Plots/SimilarityLDALDAscoreTime')