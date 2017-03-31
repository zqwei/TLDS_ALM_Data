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
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSets   = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
nFold        = 30;
cmap         = cbrewer('div', 'Spectral', 128, 'cubic');

for nSession =3 % 1:numSession
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
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);


    yesActMat   = nan(size(Y, 1), length(params.timeSeries));
    noActMat    = nan(size(Y, 1), length(params.timeSeries));
    timePoints  = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);

    figure

    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);      
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    
    
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
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

    setPrint(8*3, 6*1, ['Plots/TLDSLDASimilarityExampleSesssionAve_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
    
    close all
end