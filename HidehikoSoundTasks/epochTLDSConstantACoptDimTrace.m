addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
params.timeSeries = params.timeSeries(params.timeSeries < 1.5);
T            = length(params.timeSeries);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
xDimSet      = [ 5, 6, 4, 6, 4, 6, 4, 6, 3, 8, 8, 0, 8, 6, 6, 7];
optFitSet    = nan(size(xDimSet));
% optFitSet    = [12,13,28,2,25,12,27,26,3,2,3,NaN,20,17,7,25];

nFold        = 30;
numSession   = length(nDataSet);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    Y          = Y(:, 1:T, :);
    yDim       = size(Y, 1);
%     T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            curr_err   = nan(nFold, 1);
            for n_fold = 1:nFold
                load ([TempDatDir 'SessionHiSoundConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(n_fold) '.mat'],'Ph');
                [curr_err(n_fold),~] = loo (Y, Ph, [0 T]);
            end
            [~, optFit] = min(curr_err);
            optFitSet(nSession) = optFit;
            load ([TempDatDir 'SessionHiSoundConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
            [~, y_est, ~] = loo (Y, Ph, [0 T]);
            
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
            setPrint(6*4, 4.5*m, ['LDSTracePlots/LDSModelConstantACFit_Session_' num2str(nSession) '_xDim_' num2str(xDim) ])
        end
    end
end

close all