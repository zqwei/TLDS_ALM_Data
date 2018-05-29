addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

nData         = 17;
totTargets    = nDataSet(nData).totTargets;
numUnits      = length(nDataSet(nData).nUnit);
numTrials     = length(totTargets);
numYesTrial   = sum(totTargets);
param          = params(nDataSet(nData).task_type);

cmap                = cbrewer('div', 'RdBu', 128, 'cubic');

% KF -- SAS
nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
nSessionData  = normalizationDim(nSessionData, 2);  
coeffs        = coeffLDA(nSessionData, totTargets);
scoreMat      = nan(numTrials, size(nSessionData, 3));
rankMat       = nan(numTrials, size(nSessionData, 3));
for nTime     = 1:size(nSessionData, 3)
    scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
    rankMat(1:numYesTrial, nTime) = rankMat(1:numYesTrial, nTime)/numYesTrial;
    [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
    rankMat(1+numYesTrial:end, nTime) = rankMat(1+numYesTrial:end, nTime)/()
end

% both trial type
% figure, imagesc(rankMat)
% contra
figure
subplot(2, 2, 1)
imagesc(param.timeSeries, 1:numYesTrial, rankMat(1:numYesTrial, :))
xlim([param.timeSeries(1) param.timeSeries(end)]);
ylim([1 numYesTrial]);
axis xy;
gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
set(gca, 'YTick', [1 numYesTrial])
box off;
hold off;
xlabel('LDA score Time (s)')
ylabel('LDA score Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')
% ipsi
subplot(2, 2, 2)
imagesc(param.timeSeries, 1:(numTrials-numYesTrial), rankMat(1+numYesTrial:end, :))
xlim([param.timeSeries(1) param.timeSeries(end)]);
ylim([1 numTrials-numYesTrial]);
axis xy;
gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
set(gca, 'YTick', [1 numTrials-numYesTrial])
box off;
hold off;
xlabel('LDA score Time (s)')
ylabel('LDA score Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')

% FNS
nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
nSessionData  = normalizationDim(nSessionData, 2);  
coeffs        = coeffLDA(nSessionData, totTargets);
scoreMat      = nan(numTrials, size(nSessionData, 3));
rankMat       = nan(numTrials, size(nSessionData, 3));
for nTime     = 1:size(nSessionData, 3)
    scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    [~, rankMat(1:numYesTrial, nTime)] = sort(scoreMat(1:numYesTrial, nTime),'ascend');
    [~, rankMat(1+numYesTrial:end, nTime)] = sort(scoreMat(1+numYesTrial:end, nTime),'ascend');
end

% both trial type
% figure, imagesc(rankMat)
% contra
subplot(2, 2, 3)
imagesc(param.timeSeries, 1:numYesTrial, rankMat(1:numYesTrial, :))
xlim([param.timeSeries(1) param.timeSeries(end)]);
ylim([1 numYesTrial]);
axis xy;
gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
set(gca, 'YTick', [1 numYesTrial])
box off;
hold off;
xlabel('LDA score Time (s)')
ylabel('LDA score Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')
% ipsi
subplot(2, 2, 4)
imagesc(param.timeSeries, 1:(numTrials-numYesTrial), rankMat(1+numYesTrial:end, :))
xlim([param.timeSeries(1) param.timeSeries(end)]);
ylim([1 numTrials-numYesTrial]);
axis xy;
gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
set(gca, 'YTick', [1 numTrials-numYesTrial])
box off;
hold off;
xlabel('LDA score Time (s)')
ylabel('LDA score Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')
colorbar

setPrint(8*2, 6*2, 'Plots/Rank_order')