addpath('../Func');
setDir;
load([TempDatDir 'SimilarityIndex.mat'])

legendSet = {'Sample', 'Delay', 'Response', 'S-D', 'D-R'};
titleSet  = {'All', 'Contra', 'Ipsi'};
colorSet  = {'b', 'r', 'g', 'y', 'm'};

figure;
for nPlot = 1:length(titleSet)
    subplot(1, 3, nPlot)
    hold on
    for nEpoch = 1:size(GPFAMean, 3)
        errorbarxy(squeeze(GPFAMean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), ...
            squeeze(GPFAStd(:, nPlot, nEpoch)), squeeze(TLDSStd(:, nPlot, nEpoch)),...
            {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
    end
    plot([0 1], [0 1], '--k')
    box off
    legend(legendSet)
    legend('location', 'southeast')
    legend('boxoff')
    xlim([0 1])
    ylim([0 1])
    xlabel('GPFA similarity index')
    ylabel('TLDS similarity index')
    title(titleSet{nPlot})
end

setPrint(8*3, 6, 'Plots/SimilarityIndex_GPFA_TLDS')


figure;
for nPlot = 1:length(titleSet)
    subplot(1, 3, nPlot)
    hold on
    for nEpoch = 1:size(GPFAMean, 3)
        errorbarxy(squeeze(Boxcar150Mean(:, nPlot, nEpoch)), squeeze(Boxcar250Mean(:, nPlot, nEpoch)), ...
            squeeze(Boxcar150Std(:, nPlot, nEpoch)), squeeze(Boxcar250Std(:, nPlot, nEpoch)),...
            {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
    end
    plot([0 1], [0 1], '--k')
    box off
    legend(legendSet)
    legend('location', 'southeast')
    legend('boxoff')
    xlim([0 1])
    ylim([0 1])
    xlabel('Boxcar 150ms similarity index')
    ylabel('Boxcar 250ms similarity index')
    title(titleSet{nPlot})
end

setPrint(8*3, 6, 'Plots/SimilarityIndex_BoxCar')


figure;
for nPlot = 1:length(titleSet)
    subplot(1, 3, nPlot)
    hold on
    for nEpoch = 1:size(GPFAMean, 3)
        errorbarxy(squeeze(Boxcar250Mean(:, nPlot, nEpoch)), squeeze(TLDSMean(:, nPlot, nEpoch)), ...
            squeeze(Boxcar250Std(:, nPlot, nEpoch)), squeeze(TLDSStd(:, nPlot, nEpoch)),...
            {[colorSet{nEpoch} 'o'], colorSet{nEpoch}, colorSet{nEpoch}})
    end
    plot([0 1], [0 1], '--k')
    box off
    legend(legendSet)
    legend('location', 'southeast')
    legend('boxoff')
    xlim([0 1])
    ylim([0 1])
    xlabel('Boxcar 250ms similarity index')
    ylabel('TLDS similarity index')
    title(titleSet{nPlot})
end

setPrint(8*3, 6, 'Plots/SimilarityIndex_BoxCar_TLDS')