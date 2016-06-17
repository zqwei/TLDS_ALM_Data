addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3];
optFitSets   = [4, 25, 7, 20, 8];
nFold        = 30;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    xDim       = xDimSet(nSession);
    optFit     = optFitSets(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);


    yesActMat   = nan(size(Y, 1), length(params.timeSeries));
    noActMat    = nan(size(Y, 1), length(params.timeSeries));
    timePoints  = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
    contraIndex = false(size(Y,1), 1);

    for nUnit   = 1:size(Y, 1)
        yesTrial = squeeze(mean(Y(nUnit,:, 1:numYesTrial), 3));
        noTrial  = squeeze(mean(Y(nUnit,:, 1+numYesTrial:end), 3));
        yesActMat(nUnit, :)  = yesTrial;
        noActMat(nUnit, :)   = noTrial;
        contraIndex(nUnit)   = sum(noTrial(timePoints(2):end))<sum(yesTrial(timePoints(2):end));
    end


    figure

    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    subplot(2, 2, 1)
    hold on
    plot(params.timeSeries, scoreMat(1:8, :), '-b')
    plot(params.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('LDA score')
    title(['Score using instantaneous LDA - contra/ipsi: ' num2str(sum(contraIndex)) '/' num2str(sum(~contraIndex))])
    set(gca, 'TickDir', 'out')

    simCorrMat    = corr(scoreMat, 'type', 'Spearman');

    subplot(2, 2, 2)
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
    title('LDA score rank similarity')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
    subplot(2, 2, 3)
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
    title('LDA score rank similarity -- contra')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
    subplot(2, 2, 4)
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
    title('LDA score rank similarity -- ipsi')
    set(gca, 'TickDir', 'out')

    setPrint(8*2, 6*2, ['Plots/TLDSLDASimilarityExampleSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
end

close all