addpath('../Func');
setDir;

load([TempDatDir 'Combined_data_SLDS_fit.mat'])
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

for nSession = 17%1:numSession
    param      = params(nDataSet(nSession).task_type);
    Y          = fitData(nSession).unitTrial;
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);    
    m          = ceil(yDim/4)*2;
    
    for k       = [2 4 8]
        y_est = fitData(nSession).(sprintf('K%dyEst', k));
        y_est = permute(y_est, [2 3 1]);
        figure;
        for nNeuron = 1: yDim
            ymax1 = max(mean(squeeze(Y(nNeuron,:,1:yesTrial)),2) + std(squeeze(Y(nNeuron,:,1:yesTrial)),[],2));
            ymax2 = max(mean(squeeze(y_est(nNeuron,:,1:yesTrial)),2) + std(squeeze(y_est(nNeuron,:,1:yesTrial)),[],2));
            ymax3 = max(mean(squeeze(Y(nNeuron,:,yesTrial+1:end)),2) + std(squeeze(Y(nNeuron,:,yesTrial+1:end)),[],2));
            ymax4 = max(mean(squeeze(y_est(nNeuron,:,yesTrial+1:end)),2) + std(squeeze(y_est(nNeuron,:,yesTrial+1:end)),[],2));
            ymax  = max([ymax1, ymax2, ymax3, ymax4]);                
            subplot(m, 4, nNeuron);
            hold on;
            shadedErrorBar(param.timeSeries, mean(squeeze(Y(nNeuron,:,1:yesTrial)),2),std(squeeze(Y(nNeuron,:,1:yesTrial)),[],2),{'-b','linewid',2},0.5);
            shadedErrorBar(param.timeSeries, mean(squeeze(Y(nNeuron,:,yesTrial+1:end)),2),std(squeeze(Y(nNeuron,:,yesTrial+1:end)),[],2),{'-r','linewid',2},0.5);
            box off;
            xlim([param.timeSeries(1), param.timeSeries(end)])
            ylim([0 ymax])
            gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
            set(gca,'fontsize',10);
            xlabel('Time (ms)','fontsize',12);
            ylabel('Firing rate (Hz)','fontsize',12);
            hold off;
            subplot(m, 4, nNeuron + m/2*4);
            hold on;
            shadedErrorBar(param.timeSeries, mean(squeeze(y_est(nNeuron,:,1:yesTrial)),2),std(squeeze(y_est(nNeuron,:,1:yesTrial)),[],2),{'-b','linewid',2},0.5);
            shadedErrorBar(param.timeSeries, mean(squeeze(y_est(nNeuron,:,yesTrial+1:end)),2),std(squeeze(y_est(nNeuron,:,yesTrial+1:end)),[],2),{'-r','linewid',2},0.5);
            box off
            xlim([param.timeSeries(1), param.timeSeries(end)])
            ylim([0 ymax])
            gridxy ([param.polein, param.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
            set(gca,'fontsize',10);
            xlabel('Time (ms)','fontsize',12);
            ylabel('Firing rate (Hz)','fontsize',12);
            hold off;
        end
        setPrint(6*4, 4.5*m, ['LDSTracePlots/LDSModelFit_Session_' num2str(nSession) '_KState_' num2str(k) ])
        close all
    end
    
    
end

close all