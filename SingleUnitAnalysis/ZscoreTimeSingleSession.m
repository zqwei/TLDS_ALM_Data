addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_Spikes.mat'])    
nDataSetOld               = nDataSet;
% for nUnit                 = 1:length(nDataSet)
%     nDataSetOld(nUnit)    = rmfield(nDataSet(nUnit), {'depth_in_um', 'AP_in_um', 'ML_in_um', 'cell_type'});
% end
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
sessionIndex = [nDataSet.sessionIndex];
unitIndex    = [nDataSet.nUnit];
% choiceUnit   = [10,17,27,28,29,35,37,40,41,50,59]; % session 109
choiceUnit   = [4,5,6,10,11,17,18,31,32,33,38,39,41,50]; % session 116
selectedUnit = sessionIndex == 116 & ismember(unitIndex, choiceUnit);
zScores      = zScores(selectedUnit, :);

logPValue  = getLogPValueTscoreSpikeEpoch(nDataSet, params);
unitGroup  = plotTtestLogPSpikeEpoch (logPValue);
unitGroup  = unitGroup(selectedUnit);
% ROCimag    = ROCPop(nDataSet, params);

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
imagesc(params.timeSeries, 1:sum(selectedUnit), zScores(idx,:), [-10 10]);
colormap(cbrewer('div', 'RdBu', 128))
freezeColors
h = colorbar;
% set(h, 'YTick', 0:0.5:1)
axis xy
gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 1.0)
title('Session 17')
xlabel('Time (s)')
ylabel('Neuronal idx')
set(gca, 'YTick', [1 length(logPValue)])