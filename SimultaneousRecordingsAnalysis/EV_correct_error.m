%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explained variance for correct vs error trials
% 
%
% ==========================================
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 2019-02-04
%
%
%
addpath('../Func');
addpath('../EDLDS/Code/');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_Error_fit.mat'], 'fitErrData')
load([TempDatDir 'Combined_data_SLDS_fit.mat'], 'fitData')
numSession   = length(nDataSet);
explainedERR = nan(numSession, 1);
explainedCRR = nan(numSession, 1);
explainedESD = nan(numSession, 1);
explainedCSD = nan(numSession, 1);
explainedSig = nan(numSession, 1);
numUints     = nan(numSession, 1);

for nSession = 1:numSession-1
    if ~isempty(errDataSet(nSession).unit_yes_trial) && ~isempty(errDataSet(nSession).unit_no_trial)
        Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%         y_est      = [nDataSet(nSession).unit_KFFoward_yes_fit; nDataSet(nSession).unit_KFFoward_no_fit];
        y_est      = fitData(nSession).K8yEst;
        Y_s        = permute(Y, [2 3 1]); % unit x time x trial
        numUnit    = size(Y_s, 1);
        numUints(nSession) = numUnit;
        Y_s        = reshape(Y_s, numUnit, []);
        mean_y     = mean(mean(Y_s, 2),3);
        rand_y     = sum(remove_mean(Y_s, mean_y).^2, 2);
        errTrialC  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
        explainedCRR(nSession) = 1 - mean(errTrialC);
        errTrialC  = errTrialC(:);
        explainedCSD(nSession) = sem(1 - errTrialC);
        
        
        
        Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
%         y_est      = [errDataSet(nSession).unit_KFFoward_yes_fit; errDataSet(nSession).unit_KFFoward_no_fit];
        y_est      = fitErrData(nSession).K8yEst;
        Y_s        = permute(Y, [2 3 1]);
        numUnit    = size(Y_s, 1);
        Y_s        = reshape(Y_s, numUnit, []);
        mean_y     = mean(mean(Y_s, 2),3);
        rand_y     = sum(remove_mean(Y_s, mean_y).^2, 2);
        errTrialE  = sum(sum((Y-y_est).^2, 1), 3)./rand_y';
        errTrialE  = errTrialE(:);
        explainedERR(nSession) = 1 - mean(errTrialE);
        explainedESD(nSession) = sem(1 - errTrialE);
        explainedSig(nSession) = 1 - ttest2(errTrialE, errTrialC);
    end
end


figure;
hold on
scatter(explainedCRR(explainedSig==1), explainedERR(explainedSig==1), 'filled');
scatter(explainedCRR(explainedSig==0), explainedERR(explainedSig==0));
plot(explainedCRR, explainedERR, 'ok')
plot([-0.2 1], [-0.2 1], '--k');
hold off
xlim([-0.1 0.81])
ylim([-0.1 0.81])
xlabel('EV correct trial')
ylabel('EV error trial')
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/LDSModelFit_EV_ErrorCorrect')
% close all