addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

load([TempDatDir 'Combined_data_SLDS_trial.mat'])
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

for nSession  = 17%1:length(nDataSet)
    
    param         = params(nDataSet(nSession).task_type);
    
    figure;

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
    end

    subplot(2, 2, 1)
    hold on
    plot(param.timeSeries, scoreMat(1:8, :), '-b')
    plot(param.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
    gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('LDA score')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));

    subplot(2, 2, 2)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
    subplot(2, 2, 3)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- contra')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
    subplot(2, 2, 4)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- ipsi')
    set(gca, 'TickDir', 'out')

    setPrint(8*2, 6*2, ['Plots/LDASimilarityExampleSesssion_idx_' num2str(nSession, '%02d')])

    close all
end


for nSession  = 17%1:length(nDataSet)
    
    param         = params(nDataSet(nSession).task_type);
    
    figure;

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
    end

    subplot(2, 2, 1)
    hold on
    plot(param.timeSeries, scoreMat(1:8, :), '-b')
    plot(param.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
    gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('LDA score')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));

    subplot(2, 2, 2)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
    subplot(2, 2, 3)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- contra')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
    subplot(2, 2, 4)
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
%     colorbar
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- ipsi')
    set(gca, 'TickDir', 'out')

    setPrint(8*2, 6*2, ['Plots/LDASimilarityExampleSesssion_idx_' num2str(nSession, '%02d')])

    close all
end



for K = [2 4 8]
    for nSession  = 17%1:length(nDataSet)

        param         = params(nDataSet(nSession).task_type);

        figure;

        numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
        numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
        totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
        numUnits      = length(nDataSet(nSession).nUnit);
        numTrials     = numYesTrial + numNoTrial;
        nSessionData  = fitData(nSession).(sprintf('K%dyEst', K));
        nSessionData  = normalizationDim(nSessionData, 2);  
        coeffs        = coeffLDA(nSessionData, totTargets);
        scoreMat      = nan(numTrials, size(nSessionData, 3));
        for nTime     = 1:size(nSessionData, 3)
            scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
            scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
        end

        subplot(2, 2, 1)
        hold on
        plot(param.timeSeries, scoreMat(1:8, :), '-b')
        plot(param.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
        gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
        xlim([min(param.timeSeries) max(param.timeSeries)]);
        box off
        hold off
        xlabel('Time (s)')
        ylabel('LDA score')
        title('Score using instantaneous LDA')
        set(gca, 'TickDir', 'out')

        numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
        numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
        totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
        numUnits      = length(nDataSet(nSession).nUnit);
        numTrials     = numYesTrial + numNoTrial;
        nSessionData  = fitData(nSession).(sprintf('K%dyEst', K));
        nSessionData  = normalizationDim(nSessionData, 2);  
        coeffs        = coeffLDA(nSessionData, totTargets);
        scoreMat      = nan(numTrials, size(nSessionData, 3));
        for nTime     = 1:size(nSessionData, 3)
            scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        end

        simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));

        subplot(2, 2, 2)
        hold on
        imagesc(param.timeSeries, param.timeSeries, simCorrMat);
        xlim([min(param.timeSeries) max(param.timeSeries)]);
        ylim([min(param.timeSeries) max(param.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity')
        set(gca, 'TickDir', 'out')

        simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
        subplot(2, 2, 3)
        hold on
        imagesc(param.timeSeries, param.timeSeries, simCorrMat);
        xlim([min(param.timeSeries) max(param.timeSeries)]);
        ylim([min(param.timeSeries) max(param.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity -- contra')
        set(gca, 'TickDir', 'out')

        simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
        subplot(2, 2, 4)
        hold on
        imagesc(param.timeSeries, param.timeSeries, simCorrMat);
        xlim([min(param.timeSeries) max(param.timeSeries)]);
        ylim([min(param.timeSeries) max(param.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity -- ipsi')
        set(gca, 'TickDir', 'out')

        setPrint(8*2, 6*2, ['Plots/LDASimilarityExampleSesssion_idx_' num2str(nSession, '%02d') '_Kstate_' num2str(K)])

        close all
    end
end