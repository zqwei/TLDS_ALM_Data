addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_Spikes.mat'])    
nDataSetOld               = nDataSet;
load([TempDatDir 'Shuffle_HiSpikes.mat'])  
nDataSet                  = [nDataSetOld; nDataSet];

numUnits                  = length(nDataSet);
pValue                    = applyFuncToCompareTrialType(nDataSet, @pValueTTest2);
meanDiffValue             = applyFuncToCompareTrialType(nDataSet, @meanDiff);
logPValueZscore           = -log(pValue);
zScores                   = -sign(meanDiffValue).*logPValueZscore; 
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
set(gca, 'YTick', [1 length(logPValue)])
setPrint(16, 6, 'Plots/Zscore')