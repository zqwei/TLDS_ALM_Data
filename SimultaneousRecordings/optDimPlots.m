addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
analysisIndex = [1:8 18 26:41];
nDataSet     = nDataSet(analysisIndex);
numSession = length(nDataSet);
xDimSet    = nan(numSession, 1);
yDimSet    = nan(numSession, 1);

for nSession = 1:numSession
    xDimSet(nSession) = size(nDataSet(nSession).x_yes_fit, 2);
    yDimSet(nSession) = size(nDataSet(nSession).unit_yes_trial, 2);
end

xDimSet(9) = 4;

figure
plot(xDimSet, yDimSet, 'ok')
ylim([5 25])
xlim([1.5 5.5])
set(gca, 'xTick', 2:5, 'yTick', [5 25])
set(gca, 'TickDir', 'out')
box off
xlabel('Opt. Dim.')
ylabel('Num. units')
setPrint(8, 6, 'Plots/OptDimNumUnits')

figure
hist(xDimSet,2:5)
ylim([0 15])
xlim([1.5 5.5])
set(gca, 'xTick', 2:5, 'yTick', [5 25])
box off
xlabel('Opt. Dim.')
ylabel('Num. sessions')
setPrint(8, 6, 'Plots/OptDimNumSession')

[h, p] = ttest2(yDimSet(xDimSet == 3), yDimSet(xDimSet == 4));
[rs, p] = corr(xDimSet, yDimSet, 'type', 'Spearman');