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


load([TempDatDir 'Shuffle_Spikes.mat']);
load('cellGroup.mat')

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

%% PCA Trace
numComps  = 3;
pcaFiringRatesAverage = zeros(numComps, 2, 77);
firingRatesAverage = nanmean(firingRates, ndims(firingRates));
firingRatesAverage = [squeeze(firingRatesAverage(:, 1, :)), squeeze(firingRatesAverage(:, 2, :));];
[coeffs,score,~]        = pca(firingRatesAverage', 'NumComponents', numComps);
pcaFiringRatesAverage(:, 1, :) = score(1:77, :)';
pcaFiringRatesAverage(:, 2, :) = score(78:end, :)';

%% Coeff vs dynamical selectivity
groupIdx = cellGroup;

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

% setPrint(8*3, 6, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuron')
% 
% groupNames = {'Non.', 'Contra.', 'Ipsi.', 'Dynamical'};
% figure;
% hold on
% for nColor = 1:length(groupNames)
%     plot(0, nColor, 's', 'color', cmap(nColor,:), 'MarkerFaceColor',cmap(nColor,:),'MarkerSize', 8)
%     text(1, nColor, groupNames{nColor})
% end
% xlim([0 10])
% hold off
% axis off
% setPrint(3, 2, 'Plots/CollectedUnitsPCACoeffsDynamicalNeuronLabel')

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
    validIdx = groupIdx==nGroup & coeffs(:,1)>0;
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
% setPrint(8*3, 6*4, 'Plots/CollectedUnitsPCATracesDynamicalNeuron')