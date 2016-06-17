%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dPCA and PCA across trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

combinedParams = {{1}, {2}, {[1 2]}};
margNames      = {'Stim', 'Time', 'Inter'};
numTrials      = 100;
numFold        = 100;
numComps       = 10;
cmap = [         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];


load([TempDatDir 'Shuffle_Spikes.mat'])    
for nUnit                 = 1:length(nDataSet)
    nDataSetOld(nUnit)    = rmfield(nDataSet(nUnit), {'depth_in_um', 'AP_in_um', 'ML_in_um', 'cell_type'});
end
load([TempDatDir 'Shuffle_HiSpikes.mat'])  
nDataSet                  = [nDataSetOld'; nDataSet];

%% EV
evMat              = zeros(numFold, length(combinedParams), numComps);
firingRates        = generateDPCAData(nDataSet, numTrials);
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
pcaX               = firingRatesAverage(:,:);
firingRatesAverage = bsxfun(@minus, firingRatesAverage, mean(pcaX,2));
pcaX               = bsxfun(@minus, pcaX, mean(pcaX,2));
Xmargs             = dpca_marginalize(firingRatesAverage, 'combinedParams', combinedParams, 'ifFlat', 'yes');
totalVar           = sum(sum(pcaX.^2));
[~, ~, Wpca] = svd(pcaX');
PCAmargVar         = zeros(length(combinedParams), length(nDataSet));
for i=1:length(Xmargs)
    PCAmargVar(i,:) = sum((Wpca' * Xmargs{i}).^2, 2)' / totalVar;
end

figure;
bar(1:numComps, PCAmargVar(:, 1:numComps)','stacked')
box off
xlim([0 numComps+0.5])
ylim([0 0.3])
xlabel('Component index')
ylabel('frac. EV per PC')
colormap(cmap(1:3, :))
set(gca, 'xTick', 0:5:10)
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/CollectedUnitsPCA')    

figure;
hold on
for nColor = 1:length(margNames)
    plot(0, nColor, 's', 'color', cmap(nColor,:), 'MarkerFaceColor',cmap(nColor,:),'MarkerSize', 8)
    text(1, nColor, margNames{nColor})
end
xlim([0 10])
hold off
axis off
setPrint(3, 2, 'Plots/CollectedUnitsPCALabel')


%% PCA Trace
numComps  = 3;
pcaFiringRatesAverage = zeros(numComps, 2, 77);
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
firingRatesAverage = [squeeze(firingRatesAverage(:, 1, :)), squeeze(firingRatesAverage(:, 2, :));];
[coeffs,score,~]        = pca(firingRatesAverage', 'NumComponents', numComps);
pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
figure;
for nPlot           = 1:numComps
    subplot(1, numComps, nPlot)
    hold on
    plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
    plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
    hold off
    box off
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    xlabel('Time (s)')
    ylabel(['PC' num2str(nPlot) ' score'])  
end

setPrint(8*3, 6, 'Plots/CollectedUnitsPCATrace')

%% Coeff vs dynamical selectivity
logPValue  = getLogPValueTscoreSpikeEpoch(nDataSet, params);
unitGroup  = plotTtestLogPSpikeEpoch (logPValue);
groupIdx   = unitGroup;
groupIdx(groupIdx<=7 & groupIdx>=1)  = 1;
groupIdx(groupIdx<=14 & groupIdx>=8) = 2;
groupIdx(groupIdx== 15)              = 3;

figure;
for nPlot           = 1:numComps
    subplot(1, numComps, nPlot)
    hold on
    xi              = -0.3:0.01:0.3;
    for nGroup = 0:3
        f = ksdensity(coeffs(groupIdx==nGroup, nPlot), xi);
        plot(xi, f/max(f), '-', 'linewid', 1.0)
    end
    hold off
    box off
    xlim([-0.3 0.3]);
    xlabel(['PC' num2str(nPlot) ' Coeffs.'])
    ylabel('Normalized Prob. Density')  
end

setPrint(8*3, 6, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuron')

groupNames = {'Non.', 'Contra.', 'Ipsi.', 'Dynamical'};
figure;
hold on
for nColor = 1:length(groupNames)
    plot(0, nColor, 's', 'color', cmap(nColor,:), 'MarkerFaceColor',cmap(nColor,:),'MarkerSize', 8)
    text(1, nColor, groupNames{nColor})
end
xlim([0 10])
hold off
axis off
setPrint(3, 2, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuronLabel')

%% PCA Trace per Group
numComps  = 3;
pcaFiringRatesAverage = zeros(numComps, 2, 77);
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
firingRatesAverage = [squeeze(firingRatesAverage(:, 1, :)), squeeze(firingRatesAverage(:, 2, :));];
firingRatesAverage = bsxfun(@minus, firingRatesAverage, mean(firingRatesAverage,2));
[coeffs,~,~]        = pca(firingRatesAverage', 'NumComponents', numComps);
figure;
ylimList   = [0.31, 0.62, 0.43];
for nGroup = 0:3
    validIdx = groupIdx==nGroup;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuron')

figure
for nGroup = 0:3
    validIdx = groupIdx==nGroup & coeffs(:, 1)>0;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuronPositive')

figure
for nGroup = 0:3
    validIdx = groupIdx==nGroup & coeffs(:, 1)<0;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuronNegative')


%% Coeff vs dynamical selectivity normalized data
numComps  = 3;
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
firingRatesAverage = [squeeze(firingRatesAverage(:, 1, :)), squeeze(firingRatesAverage(:, 2, :));];
firingRatesAverage = bsxfun(@minus, firingRatesAverage, mean(firingRatesAverage,2));
firingRatesAverage = bsxfun(@rdivide, firingRatesAverage, std(firingRatesAverage,[],2));
[coeffs,score,~]        = pca(firingRatesAverage', 'NumComponents', numComps);
logPValue  = getLogPValueTscoreSpikeEpoch(nDataSet, params);
unitGroup  = plotTtestLogPSpikeEpoch (logPValue);
groupIdx   = unitGroup;
groupIdx(groupIdx<=7 & groupIdx>=1)  = 1;
groupIdx(groupIdx<=14 & groupIdx>=8) = 2;
groupIdx(groupIdx== 15)              = 3;

figure;
for nPlot           = 1:numComps
    subplot(1, numComps, nPlot)
    hold on
    xi              = -0.3:0.01:0.3;
    for nGroup = 0:3
        f = ksdensity(coeffs(groupIdx==nGroup, nPlot), xi);
        plot(xi, f/max(f), '-', 'linewid', 1.0)
    end
    hold off
    box off
    xlim([-0.3 0.3]);
    xlabel(['PC' num2str(nPlot) ' Coeffs.'])
    ylabel('Normalized Prob. Density')  
end

setPrint(8*3, 6, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuronNormalizedData')

%% PCA Trace per Group normalized data
numComps  = 3;
pcaFiringRatesAverage = zeros(numComps, 2, 77);
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
firingRatesAverage = [squeeze(firingRatesAverage(:, 1, :)), squeeze(firingRatesAverage(:, 2, :));];
firingRatesAverage = bsxfun(@minus, firingRatesAverage, mean(firingRatesAverage,2));
firingRatesAverage = bsxfun(@rdivide, firingRatesAverage, std(firingRatesAverage,[],2));
[coeffs,~,~]        = pca(firingRatesAverage', 'NumComponents', numComps);
figure;
ylimList   = [0.025, 0.066, 0.038];
for nGroup = 0:3
    validIdx = groupIdx==nGroup;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuronNormalizedData')

figure
for nGroup = 0:3
    validIdx = groupIdx==nGroup & coeffs(:, 1)>0;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuronNormalizedDataPositive')

figure
for nGroup = 0:3
    validIdx = groupIdx==nGroup & coeffs(:, 1)<0;
    score  = (coeffs(validIdx, :)' * firingRatesAverage(validIdx, :))'/sum(validIdx);
    pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
    pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';
    for nPlot           = 1:numComps
        subplot(4, numComps, nPlot + nGroup*3)
        hold on
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 1, :)), '-r', 'linewid', 2);
        plot(params.timeSeries, squeeze(pcaFiringRatesAverage(nPlot, 2, :)), '-b', 'linewid', 2);
        hold off
        box off
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([-ylimList(nPlot) ylimList(nPlot)])
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5)
        xlabel('Time (s)')
        ylabel(['PC' num2str(nPlot) ' score'])  
    end
end
setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuronNormalizedDataNegative')