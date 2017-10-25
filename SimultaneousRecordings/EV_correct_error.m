addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

analysisIndex = [1:8 18 26:42];

load([TempDatDir 'Combined_Simultaneous_Error_Spikes_LOO.mat'])
errDataSet   = nDataSet(analysisIndex);
load([TempDatDir 'Combined_Simultaneous_Spikes_LOO.mat'])
nDataSet     = nDataSet(analysisIndex);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
explainedERR = nan(numSession, 1);
explainedCRR = nan(numSession, 1);
explainedESD = nan(numSession, 1);
explainedCSD = nan(numSession, 1);
explainedSig = nan(numSession, 1);
numUints     = nan(numSession, 1);

for nSession = 1:numSession-1
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    y_est      = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    Y_s        = permute(Y, [2 3 1]);
    numUnit    = size(Y_s, 1);
    numUints(nSession) = numUnit;
    Y_s        = reshape(Y_s, numUnit, []);
    rand_y     = sum(sum(remove_mean(Y_s, nDataSet(nSession).Ph.d(:,1)).^2));
    errTrialC  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
    explainedCRR(nSession) = 1 - mean(errTrialC);
    errTrialC  = errTrialC(:);
    explainedCSD(nSession) = sem(1 - errTrialC);
    
    Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    y_est      = [errDataSet(nSession).unit_yes_fit; errDataSet(nSession).unit_no_fit];
    Y_s        = permute(Y, [2 3 1]);
    numUnit    = size(Y_s, 1);
    Y_s        = reshape(Y_s, numUnit, []);
    rand_y     = sum(sum(remove_mean(Y_s, nDataSet(nSession).Ph.d(:,1)).^2));
    errTrialE  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
    errTrialE  = errTrialE(:);
    explainedERR(nSession) = 1 - mean(errTrialE);
    explainedESD(nSession) = sem(1 - errTrialE);
    explainedSig(nSession) = 1 - ttest2(errTrialE, errTrialC);
end


figure;
hold on
scatter(explainedCRR(explainedSig==1), explainedERR(explainedSig==1), [], numUints(explainedSig==1), 'filled');
scatter(explainedCRR(explainedSig==0), explainedERR(explainedSig==0), [], numUints(explainedSig==0));
plot([-0.05 1], [-0.05 1], '--k');
% colorbar
hold off
xlim([-0.05 0.61])
ylim([-0.05 0.61])
xlabel('EV correct trial')
ylabel('EV error trial')
setPrint(8, 6, 'Plots/LDSModelFit_EV_ErrorCorrect')
close all