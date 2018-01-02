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
optFitSet    = [6,29,20,14,17,11,20,18,11,25,22,30,20,6,15,9,30,22,30,29,21,3];

explainedERR = nan(numSession, 1);
explainedCRR = nan(numSession, 1);
numUints     = nan(numSession, 1);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, ~, ~] = loo (Y, Ph, [0 T]);
    explainedCRR(nSession) = 1 - err;
    numUints(nSession)     = yDim;
    
    
    Y          = [errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    yesTrial   = size(errDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, ~] = loo (Y, Ph, [0 T]);
    explainedERR(nSession) = 1 - err;
end

% load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
% errDataSet   = nDataSet;
% load([TempDatDir 'Simultaneous_HiSpikes.mat'])
% timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
% timePoint    = timePoint(2:end-1);
% numSessionHi = length(nDataSet);
% xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
% optFitSet    = [2, 18, 9, 8, 6, 12, 11, 12, 24, 23, 13];
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
%     load ([TempDatDir 'SessionHiConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%     [err, ~, ~] = loo (Y, Ph, [0, T]);
%     explainedCRR(nSession+numSession) = 1 - err;
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
%     load ([TempDatDir 'SessionHiConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%     [err, y_est, ~] = loo (Y, Ph, [0, T]);
%     explainedERR(nSession+numSession) = 1 - err;
% end
% 
% figure;
% hold on
% scatter(explainedCRR, explainedERR, [], numUints, 'filled');
% plot([-0.05 1], [-0.05 1], '--k');
% colorbar
% hold off
% xlim([-0.05 0.6])
% ylim([-0.05 0.6])
% xlabel('EV correct trial')
% ylabel('EV error trial')
% setPrint(8, 6, 'Plots/LDSModelFitConstantAC_EV_ErrorCorrect')
% close all