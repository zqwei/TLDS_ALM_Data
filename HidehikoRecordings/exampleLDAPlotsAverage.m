addpath('../Func');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mRow = ceil(length(nDataSet)/mCol);
numFold = 10;

for nSession =3 % 1:numSession
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
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
    end

    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(1, 3, 1)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat),std(simCorrMat)/sqrt(length(simCorrMat)),{'-k','linewid',1},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
    subplot(1, 3, 2)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat),std(simCorrMat)/sqrt(length(simCorrMat)),{'-k','linewid',1},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- contra')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
    subplot(1, 3, 3)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat),std(simCorrMat)/sqrt(length(simCorrMat)),{'-k','linewid',1},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('LDA score rank similarity -- ipsi')
    set(gca, 'TickDir', 'out')

    setPrint(8*3, 6*1, ['Plots/LDASimilarityExampleSesssionAve_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
    
    close all
end