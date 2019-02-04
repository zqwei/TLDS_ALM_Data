%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error trials SVM and QDA dynamics
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
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet  = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;


cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
param               = params(nDataSet(1).task_type);
sigma               = 0.15 / param.binsize; % 300 ms
filterLength        = 11;
filterStep          = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse         = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse         = filterInUse / sum (filterInUse); 


for nSession = 17 %51:length(corrDataSet)
    param         = params(nDataSet(nSession).task_type);
    figure
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_KFFoward_yes_fit; corrDataSet(nSession).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(2, 2, 1) % correct trial rank
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_KFFoward_yes_fit; errDataSet(nSession).unit_KFFoward_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);   
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = corr(scoreMat, 'type', 'Spearman');
    subplot(2, 2, 2) % error trial rank
    hold on
    imagesc(param.timeSeries, param.timeSeries, simCorrMat);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    ylim([min(param.timeSeries) max(param.timeSeries)]);
    caxis([0 1]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    
    % SVM
    subplot(2,2,3) % reproduce of figure 5e
    nSessionData  = [corrDataSet(nSession).unit_KFFoward_yes_fit; corrDataSet(nSession).unit_KFFoward_no_fit];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_KFFoward_yes_fit; errDataSet(nSession).unit_KFFoward_no_fit];
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];
    nSessionData  = normalizationDim(nSessionData, 2);
    correctRate   = coeffSVM(nSessionData, totTargets); 
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);

    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets);  
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-k','linewid',1},0.5);
    ylim([0.4 1.01])
    gridxy ([param.polein, param.poleout, 0],[0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    set(gca, 'TickDir', 'out')
    
    %QDA
    subplot(2,2,4)
    nSessionData  = [corrDataSet(nSession).unit_KFFoward_yes_fit; corrDataSet(nSession).unit_KFFoward_no_fit];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_KFFoward_yes_fit; errDataSet(nSession).unit_KFFoward_no_fit];
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];
    nSessionData  = normalizationDim(nSessionData, 2);
    correctRate   = coeffSQDA(nSessionData, totTargets);  
    correctPrior  = mean(totTargets);
    correctRate(1, :) = (correctRate(1, :) - correctPrior)/(1 - correctPrior) * 0.5 + 0.5;
    correctRate(2, :) = correctRate(2, :)/(1 - correctPrior) * 0.5;
    
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-','linewid',1, 'color', [0.4940    0.1840    0.5560]},0.5);

    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSQDA(nSessionData, totTargets);  
    correctRate(1, :) = (correctRate(1, :) - correctPrior)/(1 - correctPrior) * 0.5 + 0.5;
    correctRate(2, :) = correctRate(2, :)/(1 - correctPrior) * 0.5;      
    hold on
    shadedErrorBar(param.timeSeries, getGaussianPSTH(filterInUse, correctRate(1,:),2),correctRate(2,:),{'-k','linewid',1},0.5);
    ylimValue = ylim;
    ylim([ylimValue(1) min(1, ylimValue(2))])
    ylim([0.4 1.01])
    gridxy ([param.polein, param.poleout, 0],[0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    set(gca, 'TickDir', 'out')
    
    
    setPrint(8*2, 6*2, ['Plots/Error_Trial_KFFoward_idx_' num2str(nSession)])
    close all
end

