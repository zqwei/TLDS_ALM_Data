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

    simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
    subplot(2, 4, 1)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(1)-4:timePoint(1),:)),std(simCorrMat(timePoint(1)-4:timePoint(1),:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(1)-4)],[], 'Color','g','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 2)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)-5:timePoint(2),:)),std(simCorrMat(timePoint(2)-5:timePoint(2),:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(2)-5)],[], 'Color','g','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 3)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)+13:timePoint(2)+18,:)),std(simCorrMat(timePoint(2)+13:timePoint(2)+18,:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(2)+13), params.timeSeries(timePoint(2)+18)],[], 'Color','g','Linestyle','--','linewid', 0.5);    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 4)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(3):timePoint(3)+5,:)),std(simCorrMat(timePoint(3):timePoint(3)+5,:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(3)+5)],[], 'Color','g','Linestyle','--','linewid', 0.5);    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')

    simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
    subplot(2, 4, 5)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(1)-4:timePoint(1),:)),std(simCorrMat(timePoint(1)-4:timePoint(1),:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(1)-4)],[], 'Color','g','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 6)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)-5:timePoint(2),:)),std(simCorrMat(timePoint(2)-5:timePoint(2),:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(2)-5)],[], 'Color','g','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 7)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)+13:timePoint(2)+18,:)),std(simCorrMat(timePoint(2)+13:timePoint(2)+18,:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(2)+13), params.timeSeries(timePoint(2)+18)],[], 'Color','g','Linestyle','--','linewid', 0.5);    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    subplot(2, 4, 8)
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(3):timePoint(3)+5,:)),std(simCorrMat(timePoint(3):timePoint(3)+5,:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(3)+5)],[], 'Color','g','Linestyle','--','linewid', 0.5);    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    setPrint(8*4, 6*2, ['Plots/TLDSLDASimilarityExampleSesssionAve_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
    
    close all
end


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

    simCorrMat   = corr(scoreMat, 'type', 'Spearman');
    figure;
    hold on
    shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)-4:timePoint(2)+1,:)),std(simCorrMat(timePoint(2)-4:timePoint(2)+1,:))/sqrt(6),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([0 1]);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    gridxy ([params.timeSeries(timePoint(2)-4)],[], 'Color','g','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    set(gca, 'TickDir', 'out')
    
    setPrint(8, 6, ['Plots/TLDSLDASimilarityExampleSesssionAve2_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
    
    close all
end