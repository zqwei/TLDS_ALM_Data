addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes_LOO.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes_LOO.mat'])
corrDataSet  = nDataSet;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

% analysis of error session figure 5de
% session index 10, 11, 19 (11 is already in figure 5de)
sessionToAnalysis = [10 11 19];

for nSession = 19 %sessionToAnalysis
    
    figure
    
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_yes_fit; corrDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(1, 3, 1) % correct trial rank
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
    title('Correct LDA score rank similarity')
    set(gca, 'TickDir', 'out')
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_yes_fit; errDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(1, 3, 2) % error trial rank
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
    title('Error LDA score rank similarity')
    set(gca, 'TickDir', 'out')
    
    
    subplot(1,3,3) % reproduce of figure 5e
    nSessionData  = [corrDataSet(nSession).unit_yes_fit; corrDataSet(nSession).unit_no_fit];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_fit; errDataSet(nSession).unit_no_fit];
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets);
    
    hold on
    shadedErrorBar(params.timeSeries, correctRate,sqrt(correctRate.*(1-correctRate)/length(totTargets)),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);
    
    
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets);  
      
    hold on
    shadedErrorBar(params.timeSeries, correctRate,sqrt(correctRate.*(1-correctRate)/length(totTargets)),{'-k','linewid',1},0.5);
    gridxy ([params.polein, params.poleout, 0],[mean(totTargets)], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')
    
    setPrint(8*3, 6, ['Plots/Error_Trial_Dynamics_idx_' num2str(nSession)])
end