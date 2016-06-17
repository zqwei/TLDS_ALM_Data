addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'SimultaneousError_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];
explainedERR = nan(numSession, 1);
explainedCRR = nan(numSession, 1);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, ~, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedCRR(nSession) = 1 - err;
    
    
    Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    yesTrial   = size(errDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedERR(nSession) = 1 - err;
            
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
    end
    setPrint(6*4, 4.5*m, ['LDSTracePlots/LDSModelFit_ErrorSession_' num2str(nSession) '_xDim_' num2str(xDim) ])
end

figure;
hold on
plot(explainedCRR, explainedERR, 'ok');
plot([0 1], [0 1], '--k');
hold off
xlim([0 0.5])
ylim([0 0.5])
xlabel('EV correct trial')
ylabel('EV error trial')
setPrint(8, 6, 'Plots/LDSModelFit_EV_ErrorCorrect')
close all