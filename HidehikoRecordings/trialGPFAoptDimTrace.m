addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [1, 3, 4, 2, 5, 8, 6, 4, 6, 6, 8, 8, 6, 6, 10, 6, 6, 4];

for nSession = 1:numSession    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
            y_est = nan(size(Y));
            
            for nTrial = 1:size(Y, 3)
                y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
                y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
                y_est_nTrial (y_est_nTrial <0) = 0;
                y_est_nTrial = y_est_nTrial.^2;
                y_est(:, :, nTrial) = y_est_nTrial;
            end
            
            figure;
            for nNeuron = 1: yDim
                ymax1 = max(mean(squeeze(Y(nNeuron,:,1:yesTrial)),2) + std(squeeze(Y(nNeuron,:,1:yesTrial)),[],2));
                ymax2 = max(mean(squeeze(y_est(nNeuron,:,1:yesTrial)),2) + std(squeeze(y_est(nNeuron,:,1:yesTrial)),[],2));
                ymax3 = max(mean(squeeze(Y(nNeuron,:,yesTrial+1:end)),2) + std(squeeze(Y(nNeuron,:,yesTrial+1:end)),[],2));
                ymax4 = max(mean(squeeze(y_est(nNeuron,:,yesTrial+1:end)),2) + std(squeeze(y_est(nNeuron,:,yesTrial+1:end)),[],2));
                ymax  = max([ymax1, ymax2, ymax3, ymax4]);                
                subplot(m, 4, nNeuron);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,1:yesTrial)),2),std(squeeze(Y(nNeuron,:,1:yesTrial)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,yesTrial+1:end)),2),std(squeeze(Y(nNeuron,:,yesTrial+1:end)),[],2),{'-r','linewid',2},0.5);
                box off;
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
                set(gca, 'TickDir', 'out')
                subplot(m, 4, nNeuron + m/2*4);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,1:yesTrial)),2),std(squeeze(y_est(nNeuron,:,1:yesTrial)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,yesTrial+1:end)),2),std(squeeze(y_est(nNeuron,:,yesTrial+1:end)),[],2),{'-r','linewid',2},0.5);
                box off
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
                set(gca, 'TickDir', 'out')
            end
            setPrint(6*4, 4.5*m, ['GPFATracePlots/GPFAModelFit_Session_' num2str(nSession) '_xDim_' num2str(xDim) ])
        end
    end
    
end

close all