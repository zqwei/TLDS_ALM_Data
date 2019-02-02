addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_HiSoundSpikes.mat'])    
params.timeSeries = params.timeSeries(params.timeSeries < 1.5);

numUnits                  = length(nDataSet);
pValue                    = applyFuncToCompareTrialType(nDataSet, @pValueTTest2);
meanDiffValue             = applyFuncToCompareTrialType(nDataSet, @meanDiff);
logPValueZscore           = -log(pValue);
zScores                   = -sign(meanDiffValue).*logPValueZscore; 
zScores                   = zScores(:, 1:length(params.timeSeries));
% yes  -- blue trial
% no   -- red trial
zScores(isnan(zScores))   = 0;


logPValue  = getLogPValueTscoreSpikeEpoch(nDataSet, params);
unitGroup  = plotTtestLogPSpikeEpoch (logPValue);
ROCimag    = ROCPop(nDataSet, params);

[groupIdx, idx]   = sort(unitGroup, 'ascend');

groupIdx(groupIdx<=7 & groupIdx>=1)  = 1;
groupIdx(groupIdx<=14 & groupIdx>=8) = 2;
groupIdx(groupIdx== 15)              = 3;

figure;
subplot (1, 10, 1)
imagesc(groupIdx, [0 3])
colormap(gray)
freezeColors
set(gca, 'XTick', [], 'YTick', [])
axis xy
subplot (1, 10, [3 10])
imagesc(params.timeSeries, 1:numUnits, zScores(idx,:), [-10 10]);
colormap(cbrewer('div', 'RdBu', 128))
freezeColors
h = colorbar;
axis xy
gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 1.0)
xlabel('Time (s)')
ylabel('Neuronal idx')
xlim([params.timeSeries(1) params.timeSeries(end)])
set(gca, 'YTick', [1 length(logPValue)])
set(gca, 'TickDir', 'out')
setPrint(16, 6, 'Plots/Zscore')
