addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
numSession = length(nDataSet);
xDimSet    = nan(numSession, 1);
yDimSet    = nan(numSession, 1);
taskList   = nan(numSession, 1);

for nSession = 1:numSession
    xDimSet(nSession) = size(nDataSet(nSession).KFPh.A, 1);
    yDimSet(nSession) = length(nDataSet(nSession).nUnit);
    taskList(nSession) = nDataSet(nSession).task_type;
end

for task = 1:2
    ind  = taskList == task;
    figure
    plot(xDimSet(ind), yDimSet(ind), 'ok')
    ylim([5 32])
    xlim([1.5 8.5])
    set(gca, 'xTick', 2:8, 'yTick', [5 30])
    set(gca, 'TickDir', 'out')
    box off
    xlabel('Opt. Dim.')
    ylabel('Num. units')
    setPrint(8, 6, ['Plots/OptDimNumUnits_task_' num2str(task)])

    figure
    hist(xDimSet(ind),2:8)
%     ylim([0 15])
    xlim([1.5 8.5])
    set(gca, 'xTick', 2:8, 'yTick', [5 25])
    box off
    xlabel('Opt. Dim.')
    ylabel('Num. sessions')
    setPrint(8, 6, ['Plots/OptDimNumSession_task_' num2str(task)])

    [h, p] = ttest2(yDimSet(xDimSet == 3), yDimSet(xDimSet == 4));
    [rs, p] = corr(xDimSet, yDimSet, 'type', 'Spearman');
end