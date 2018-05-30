addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet  = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;


param               = params(nDataSet(1).task_type);
sigma               = 0.15 / param.binsize; % 300 ms
filterLength        = 11;
filterStep          = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse         = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse         = filterInUse / sum (filterInUse); 

% analysis of error session figure 5de
% session index 11, 19, 22, 23 (11 is already in figure 5de)
% sessionToAnalysis = [18 20];

for nSession = [13 14 17 25 28 33]
    param         = params(nDataSet(nSession).task_type);
    figure
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_KF_yes_fit; corrDataSet(nSession).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    aveMat        = mean(scoreMat);
    scoreMat      = bsxfun(@minus, scoreMat, aveMat);
    scoreMat      = getGaussianPSTH(filterInUse, scoreMat);
    subplot(2, 1, 1) % correct trial rank
    hold on
    shadedErrorBar(param.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets)), {'-b'})
    shadedErrorBar(param.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :))/sqrt(sum(~totTargets)), {'-r'})
    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_KF_yes_fit; errDataSet(nSession).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);   
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    scoreMat      = bsxfun(@minus, scoreMat, aveMat);
    scoreMat      = getGaussianPSTH(filterInUse, scoreMat);
    hold on
    shadedErrorBar(param.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets)), {'-', 'color', [0, 191, 255]/255})
    shadedErrorBar(param.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :))/sqrt(sum(~totTargets)), {'-', 'color', [255, 0, 128]/255})

    xlim([min(param.timeSeries) max(param.timeSeries)]);
%     ylim([min(param.timeSeries) max(param.timeSeries)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('Time (s)')
    ylabel('LDA score (s)')
    set(gca, 'TickDir', 'out')
    
    
    totTargets    = corrDataSet(nSession).totTargets;
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    aveMat        = mean(scoreMat);
    scoreMat      = bsxfun(@minus, scoreMat, aveMat);
    scoreMat      = getGaussianPSTH(filterInUse, scoreMat);
    subplot(2, 1, 2) % correct trial rank
    hold on
    shadedErrorBar(param.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets)), {'-b'})
    shadedErrorBar(param.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :))/sqrt(sum(~totTargets)), {'-r'})

    
    totTargets    = errDataSet(nSession).totTargets;
    nSessionData  = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);   
    scoreMat      = nan(length(totTargets), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    scoreMat      = bsxfun(@minus, scoreMat, aveMat);
    scoreMat      = getGaussianPSTH(filterInUse, scoreMat);
    hold on
    shadedErrorBar(param.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets))*2, {'-', 'color', [0, 191, 255]/255})
    shadedErrorBar(param.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :)/sqrt(sum(~totTargets)))*2, {'-', 'color', [255, 0, 128]/255})

    xlim([min(param.timeSeries) max(param.timeSeries)]);
%     ylim([min(param.timeSeries) max(param.timeSeries)]);
    axis xy;
    gridxy ([param.polein, param.poleout, 0],[0], 'Color','k','Linestyle','--','linewid', 0.5);
    box off;
    hold off;
    xlabel('Time (s)')
    ylabel('LDA score (s)')
    set(gca, 'TickDir', 'out')
 
    
    setPrint(8*1, 6*2, ['Plots/Error_Trial_Rank_Ave_idx_' num2str(nSession)])
    close all
end