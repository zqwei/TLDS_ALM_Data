addpath('../Func');
setDir;

cmap = cbrewer('qual', 'Set1', 10, 'cubic');

load([TempDatDir 'Combined_data_SLDS_fit.mat'])
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

for nSession = 1:numSession
    param       = params(nDataSet(nSession).task_type);
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    
    for k       = [2 4 8]
        statseq = fitData(nSession).(sprintf('K%dstate', k));
        figure;
        hold on       
        
        imagesc(param.timeSeries, 1:size(statseq, 1), statseq);
        xlim([min(param.timeSeries) max(param.timeSeries)]);
        ylim([1 size(statseq, 1)]);
        caxis([0 8]);
        axis xy;
        gridxy ([param.polein, param.poleout, 0], numYesTrial, 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('Time (s)')
        ylabel('Trial index')
        set(gca, 'YTick', [1 numYesTrial size(statseq, 1)])
        colormap(cmap)
        set(gca, 'TickDir', 'out')
        
        hold off;
        setPrint(8, 6, ['LDSTracePlots/LDSModelStateFit_Session_' num2str(nSession) '_KState_' num2str(k) ])
    end
    
    
end

close all