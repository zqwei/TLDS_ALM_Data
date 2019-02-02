addpath('../Func');
setDir;

cmap = cbrewer('qual', 'Set1', 10, 'cubic');

load([TempDatDir 'Combined_data_SLDS_fit.mat'])
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

for nSession = 17%1:numSession
    param       = params(nDataSet(nSession).task_type);
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    totTargets  = nDataSet(nSession).totTargets;
    
    for k       = [2 4 8]
        statseq = fitData(nSession).(sprintf('K%dstate', k));
        stateswitch = statseq(:, 1:end-1)~=statseq(:, 2:end);
        
        figure;
        hold on       
        histswitch = [0, mean(stateswitch(totTargets, :))];
        disp(mean(sum(stateswitch(totTargets, :), 2)))
        disp(std(sum(stateswitch(totTargets, :), 2)))
        stairs(param.timeSeries, histswitch, '-b');
        histswitch = [0, mean(stateswitch(~totTargets, :))];
        disp(mean(sum(stateswitch(~totTargets, :), 2)))
        disp(std(sum(stateswitch(~totTargets, :), 2)))
        stairs(param.timeSeries, histswitch, '-r');
        xlim([param.timeSeries(2) max(param.timeSeries)]);
        ylim([0 1]);
        axis xy;
        gridxy ([param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('Time (s)')
        ylabel('Frac. Switch')
        set(gca, 'YTick', [0 1])
        colormap(cmap)
        set(gca, 'TickDir', 'out')
        
        hold off;
        setPrint(8, 6, ['LDSTracePlots/LDSModelStateFractionFit_Session_' num2str(nSession) '_KState_' num2str(k) ])
    end
    
    
end

close all


for k = [2 4 8]    
    stateList       = zeros(length(nDataSet), 77*2);
    taskList        = zeros(length(nDataSet), 1);
    switch_left     = [];
    switch_right    = [];
    for nSession    = 1:length(nDataSet)
        taskList(nSession) = nDataSet(nSession).task_type; 
        totTargets  = nDataSet(nSession).totTargets;
        statseq = fitData(nSession).(sprintf('K%dstate', k));
        stateswitch = statseq(:, 1:end-1)~=statseq(:, 2:end);
        stateList(nSession, 2:end/2) = mean(stateswitch(totTargets, :));
        stateList(nSession, end/2+2:end) = mean(stateswitch(~totTargets, :));
        switch_left = [switch_left; sum(stateswitch(totTargets, :), 2), ones(sum(totTargets), 1)*nDataSet(nSession).task_type];
        switch_right = [switch_left; sum(stateswitch(~totTargets, :), 2), ones(sum(~totTargets), 1)*nDataSet(nSession).task_type];
    end
    
    for task        = 1:2
        param       = params(task);
        ind         = taskList == task;
        disp(mean(switch_left(switch_left(:,2)==task, 1)))
        disp(std(switch_left(switch_left(:,2)==task, 1)))
        disp(mean(switch_right(switch_right(:,2)==task, 1)))
        disp(std(switch_right(switch_right(:,2)==task, 1)))
        figure;
        hold on               
        shadedErrorBar(param.timeSeries, mean(stateList(ind,1:end/2)), std(stateList(ind,1:end/2)/sqrt(sum(ind))),{'-b','linewid',0.5},0.5);
        shadedErrorBar(param.timeSeries, mean(stateList(ind,1+end/2:end)), std(stateList(ind,1+end/2:end)/sqrt(sum(ind))),{'-r','linewid',0.5},0.5);
        xlim([param.timeSeries(2) max(param.timeSeries)]);
        ylim([0 1]);
        axis xy;
        gridxy ([param.polein, param.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('Time (s)')
        ylabel('Frac. Switch')
        set(gca, 'YTick', [0 1])
        colormap(cmap)
        set(gca, 'TickDir', 'out')
        
        hold off;
        setPrint(8, 6, ['LDSTracePlots/LDSModelStateFractionFit_Session_' num2str(nSession) '_KState_' num2str(k) '_Task_' num2str(task)])

    end
    
    
end
