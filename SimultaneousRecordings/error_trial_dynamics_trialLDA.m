addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes_LOO.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes_LOO.mat'])
corrDataSet  = nDataSet;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

for nSession = 1:length(corrDataSet) - 1
    
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
    subplot(2, 2, 1) % correct trial rank
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
%     title('Correct LDA score rank similarity')
    set(gca, 'TickDir', 'out')
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_yes_fit; errDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(2, 2, 2) % error trial rank
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
%     title('Error LDA score rank similarity')
    set(gca, 'TickDir', 'out')
    
    
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(2, 2, 3) % correct trial rank
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
%     title('Correct LDA score rank similarity')
    set(gca, 'TickDir', 'out')
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(2, 2, 4) % error trial rank
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
%     title('Error LDA score rank similarity')
    set(gca, 'TickDir', 'out')    
    

    
    setPrint(8*2, 6*2, ['Plots/Error_Trial_Dynamics_LDA_idx_' num2str(nSession)])
end

close all