addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'SimultaneousError_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27, 9,11, 9,30,13,11,30,25,11, 9,30,22, 1,15];
explainedERR = nan(numSession, 1);
explainedCRR = nan(numSession, 1);
explainedESD = nan(numSession, 1);
explainedCSD = nan(numSession, 1);
explainedSig = nan(numSession, 1);
numUints     = nan(numSession, 1);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, rand_y] = loo (Y, Ph, [0, timePoint, T]);
    errTrialC  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
    explainedCRR(nSession) = 1 - err;
    errTrialC  = errTrialC(:);
    explainedCSD(nSession) = sem(1 - errTrialC);
    
    numUints(nSession)     = yDim;    
    Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    yesTrial   = size(errDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    m          = ceil(yDim/4)*2;
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, rand_y] = loo (Y, Ph, [0, timePoint, T]);
    errTrialE  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
    errTrialE  = errTrialE(:);
    explainedERR(nSession) = 1 - err;
    explainedESD(nSession) = sem(1 - errTrialE);
    
    explainedSig(nSession) = 1 - ttest2(errTrialE, errTrialC);
    
end

% load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
% errDataSet   = nDataSet;
% load([TempDatDir 'Simultaneous_HiSpikes.mat'])
% timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
% timePoint    = timePoint(2:end-1);
% numSessionHi = length(nDataSet);
% xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
% optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];
% 
% for nSession = 1:numSessionHi
%     Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
%     Y          = permute(Y, [2 3 1]);
%     yDim       = size(Y, 1);
%     T          = size(Y, 2);
%     
%     xDim       = xDimSet(nSession);
%     optFit     = optFitSet(nSession);
%     load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%     [err, y_est, rand_y] = loo (Y, Ph, [0, timePoint, T]);
%     errTrialC  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
%     errTrialC  = errTrialC(:);
%     explainedCRR(nSession+numSession) = 1 - err;
%     explainedCSD(nSession+numSession) = sem(1 - errTrialC);
%     numUints(nSession+numSession)     = yDim;
%     
%     
%     Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
%     yesTrial   = size(errDataSet(nSession).unit_yes_trial, 1);
%     Y          = permute(Y, [2 3 1]);
%     yDim       = size(Y, 1);
%     T          = size(Y, 2);
%     
%     m          = ceil(yDim/4)*2;
%     xDim       = xDimSet(nSession);
%     optFit     = optFitSet(nSession);
%     load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%     [err, y_est, rand_y] = loo (Y, Ph, [0, timePoint, T]);
%     errTrialE  = sum(sum((Y-y_est).^2, 2), 1)./rand_y * size(Y, 3);
%     errTrialE  = errTrialE(:);
%     explainedERR(nSession+numSession) = 1 - err;
%     explainedESD(nSession+numSession) = sem(1 - errTrialE);    
%     explainedSig(nSession+numSession) = 1 - ttest2(errTrialE, errTrialC);    
%     
% end
% 
% figure;
% hold on
% scatter(explainedCRR(explainedSig==1), explainedERR(explainedSig==1), [], numUints(explainedSig==1), 'filled');
% scatter(explainedCRR(explainedSig==0), explainedERR(explainedSig==0), [], numUints(explainedSig==0));
% plot([-0.05 1], [-0.05 1], '--k');
% colorbar
% hold off
% xlim([-0.05 0.6])
% ylim([-0.05 0.6])
% xlabel('EV correct trial')
% ylabel('EV error trial')
% setPrint(8, 6, 'Plots/LDSModelFit_EV_ErrorCorrect')
% close all