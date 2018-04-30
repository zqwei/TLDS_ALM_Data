addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');


load([TempDatDir 'Combined_Shuffle_Spikes.mat'])

numShfTrials = 200;

for nData = 17%1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
    nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
%     nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    
    % shf trials
    totTargetsShf = [true(numShfTrials, 1); false(numShfTrials, 1)];
    numTrials     = length(totTargetsShf);
    numYesTrial   = sum(totTargetsShf);
    nSessionData  = [nDataSet(nData).unit_KFShf_yes_fit; nDataSet(nData).unit_KFShf_no_fit];
%     nSessionData  = [nDataSet(nData).unit_yes_Shftrial; nDataSet(nData).unit_no_Shftrial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargetsShf);
    scoreShfMat   = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreShfMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    
    figure;
    subplot(3, 2, 1)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreMat, 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Sim')
    set(gca, 'TickDir', 'out')

    subplot(3, 2, 2)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreShfMat, 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Shuffle')
    set(gca, 'TickDir', 'out')
    
    subplot(3, 2, 3)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreMat(totTargets, :), 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Sim')
    set(gca, 'TickDir', 'out')

    subplot(3, 2, 4)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreShfMat(totTargetsShf, :), 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Shuffle')
    set(gca, 'TickDir', 'out')
    
    subplot(3, 2, 5)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreMat(~totTargets, :), 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Sim')
    set(gca, 'TickDir', 'out')

    subplot(3, 2, 6)
    hold on
    imagesc(param.timeSeries, param.timeSeries, abs(corr(scoreShfMat(~totTargetsShf, :), 'type', 'spearman')), [0, 1])
    xlim([param.timeSeries(1) param.timeSeries(end)]);
    ylim([param.timeSeries(1) param.timeSeries(end)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    title('Bilateral Shuffle')
    set(gca, 'TickDir', 'out')
    
    setPrint(8*2, 6*3, ['Plots/Sim_Shf_Comparison_Session_' num2str(nData, '%02d')])
    close all
end