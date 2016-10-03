addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [  2,  2,  4,  2,  3,  2,  4,  2;
                  0,  3,  0,  0,  4,  0,  0,  3];
optDim       =  [18, 24, 24, 11, 19, 20,  5, 26;
                  0, 29,  0,  0, 11,  0,  0, 24];
nFold        = 30;


for nSession = 1:numSession
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = false(numYesTrial+numNoTrial, nFold);
    totTargets(1:numYesTrial, :) = true;
    totTargets    = totTargets(:);
    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            optFit        = optDim(nDim, nSession);
            load ([TempDatDir 'ShfSession_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph','Y');
            yDim       = size(Y, 1);
            T          = size(Y, 2);    
            m          = ceil(yDim/4)*2;            
            [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
            figure;
            for nNeuron = 1: yDim
                ymax1 = max(mean(squeeze(Y(nNeuron,:,totTargets)),2) + std(squeeze(Y(nNeuron,:,totTargets)),[],2));
                ymax2 = max(mean(squeeze(y_est(nNeuron,:,totTargets)),2) + std(squeeze(y_est(nNeuron,:,totTargets)),[],2));
                ymax3 = max(mean(squeeze(Y(nNeuron,:,~totTargets)),2) + std(squeeze(Y(nNeuron,:,~totTargets)),[],2));
                ymax4 = max(mean(squeeze(y_est(nNeuron,:,~totTargets)),2) + std(squeeze(y_est(nNeuron,:,~totTargets)),[],2));
                ymax  = max([ymax1, ymax2, ymax3, ymax4]);                
                subplot(m, 4, nNeuron);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,totTargets)),2),std(squeeze(Y(nNeuron,:,totTargets)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,~totTargets)),2),std(squeeze(Y(nNeuron,:,~totTargets)),[],2),{'-r','linewid',2},0.5);
                box off;
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
                subplot(m, 4, nNeuron + m/2*4);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,totTargets)),2),std(squeeze(y_est(nNeuron,:,totTargets)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,~totTargets)),2),std(squeeze(y_est(nNeuron,:,~totTargets)),[],2),{'-r','linewid',2},0.5);
                box off
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
            end
            setPrint(6*4, 4.5*m, ['LDSTracePlots/LDSModelFit_Session_' num2str(nSession) '_xDim_' num2str(xDim) ])
        end
    end
end

close all


load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [  3,  3,  3,  3,  2;
                  0,  0,  4,  0,  3];
optDim       = [ 24, 27,  6, 28,  9;
                  0,  0,  1,  0, 25];
nFold        = 30;

for nSession = 1:numSession
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = false(numYesTrial+numNoTrial, nFold);
    totTargets(1:numYesTrial, :) = true;
    totTargets    = totTargets(:);
    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            optFit        = optDim(nDim, nSession);
            load ([TempDatDir 'ShfSessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph','Y');
            yDim       = size(Y, 1);
            T          = size(Y, 2);    
            m          = ceil(yDim/4)*2;            
            [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
            figure;
            for nNeuron = 1: yDim
                ymax1 = max(mean(squeeze(Y(nNeuron,:,totTargets)),2) + std(squeeze(Y(nNeuron,:,totTargets)),[],2));
                ymax2 = max(mean(squeeze(y_est(nNeuron,:,totTargets)),2) + std(squeeze(y_est(nNeuron,:,totTargets)),[],2));
                ymax3 = max(mean(squeeze(Y(nNeuron,:,~totTargets)),2) + std(squeeze(Y(nNeuron,:,~totTargets)),[],2));
                ymax4 = max(mean(squeeze(y_est(nNeuron,:,~totTargets)),2) + std(squeeze(y_est(nNeuron,:,~totTargets)),[],2));
                ymax  = max([ymax1, ymax2, ymax3, ymax4]);                
                subplot(m, 4, nNeuron);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,totTargets)),2),std(squeeze(Y(nNeuron,:,totTargets)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(Y(nNeuron,:,~totTargets)),2),std(squeeze(Y(nNeuron,:,~totTargets)),[],2),{'-r','linewid',2},0.5);
                box off;
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
                subplot(m, 4, nNeuron + m/2*4);
                hold on;
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,totTargets)),2),std(squeeze(y_est(nNeuron,:,totTargets)),[],2),{'-b','linewid',2},0.5);
                shadedErrorBar(params.timeSeries, mean(squeeze(y_est(nNeuron,:,~totTargets)),2),std(squeeze(y_est(nNeuron,:,~totTargets)),[],2),{'-r','linewid',2},0.5);
                box off
                xlim([params.timeSeries(1), params.timeSeries(end)])
                ylim([0 ymax])
                gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
                set(gca,'fontsize',10);
                xlabel('Time (ms)','fontsize',12);
                ylabel('Firing rate (Hz)','fontsize',12);
                hold off;
            end
            setPrint(6*4, 4.5*m, ['LDSTracePlots/LDSModelFit_SessionHi_' num2str(nSession) '_xDim_' num2str(xDim) ])
        end
    end
end

close all