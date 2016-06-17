addpath('../Func');
setDir;

load([TempDatDir 'Shuffle_Spikes.mat'])    
for nUnit                 = 1:length(nDataSet)
    nDataSetOld(nUnit)    = rmfield(nDataSet(nUnit), {'depth_in_um', 'AP_in_um', 'ML_in_um', 'cell_type'});
end
load([TempDatDir 'Shuffle_HiSpikes.mat'])  
nDataSet                  = [nDataSetOld'; nDataSet];

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
imagesc(ROCimag(idx, :), [0 1])
colormap(cbrewer('div', 'RdBu', 128))
freezeColors
h = colorbar;
set(h, 'YTick', 0:0.5:1)
axis xy
set(gca, 'XTick', 1:4, 'YTick', [1 length(logPValue)], 'XTickLabel', {'', 'Sample', 'Delay', 'Response'})
xlabel('Epoch')
ylabel('Neuronal idx')
setPrint(16, 6, 'Plots/ROCEpochs')