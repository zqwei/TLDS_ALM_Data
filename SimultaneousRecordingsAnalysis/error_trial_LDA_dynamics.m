%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error trials LDA dynamics
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
addpath('../EDLDS/Code');
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


for nSession = [13 14 17 25 28 33]
    param         = params(nDataSet(nSession).task_type);
    timePoint     = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    figure
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_KF_yes_fit; corrDataSet(nSession).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));
    simCorrMat    = getGaussianPSTH(filterInUse, simCorrMat);
    subplot(2, 1, 1) % correct trial rank
    hold on
    shadedErrorBar(param.timeSeries, mean(simCorrMat(timePoint(3)-4:timePoint(3)+0, :)), std(simCorrMat(timePoint(3)-2:timePoint(3)+2, :))/sqrt(5), {'-g'})   
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_KF_yes_fit; errDataSet(nSession).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);   
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));
    simCorrMat    = getGaussianPSTH(filterInUse, simCorrMat);
    hold on
    shadedErrorBar(param.timeSeries, mean(simCorrMat(timePoint(3)-4:timePoint(3)+0, :)), std(simCorrMat(timePoint(3)-2:timePoint(3)+2, :))/sqrt(5), {'-m'})   
    ylim([0 1]);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    
    
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));
    simCorrMat    = getGaussianPSTH(filterInUse, simCorrMat);

    subplot(2,1,2)
    hold on
    shadedErrorBar(param.timeSeries, mean(simCorrMat(timePoint(3)-4:timePoint(3)+0, :)), std(simCorrMat(timePoint(3)-2:timePoint(3)+2, :))/sqrt(5), {'-g'})   
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);   
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    simCorrMat    = abs(corr(scoreMat, 'type', 'Spearman'));
    simCorrMat    = getGaussianPSTH(filterInUse, simCorrMat);
    hold on
    shadedErrorBar(param.timeSeries, mean(simCorrMat(timePoint(3)-4:timePoint(3)+0, :)), std(simCorrMat(timePoint(3)-2:timePoint(3)+2, :))/sqrt(5), {'-m'})   
    ylim([0 1]);
    xlim([min(param.timeSeries) max(param.timeSeries)]);
    gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('LDA score Time (s)')
    ylabel('LDA score Time (s)')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    
    setPrint(8, 6*2, ['Plots/Error_Trial_Rank_Sample_idx_' num2str(nSession)], 'pdf')
    close all
end