addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])

mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];
contra_corr  = nan(numSession, 1);
ipsi_corr    = nan(numSession, 1);
contra_rtVar = nan(numSession, 1);
ipsi_rtVar   = nan(numSession, 1);
explainedCRR = nan(numSession, 1);


for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedCRR(nSession) = 1 - err;
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nDataSet(nSession).firstLickTime;
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    contra_corr(nSession)  = corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman');
    ipsi_corr(nSession)    = corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman');
    contra_rtVar(nSession) = std(firstLickTime(totTargets));
    ipsi_rtVar(nSession)   = std(firstLickTime(~totTargets));    
end

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSessionHi   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3];
optFitSet    = [4, 25, 7, 20, 8];


for nSession = 1:numSessionHi
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedCRR(nSession+numSession) = 1 - err;
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nDataSet(nSession).firstLickTime;
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end

    contra_corr(nSession+numSession)  = corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman');
    ipsi_corr(nSession+numSession)    = corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman');
    contra_rtVar(nSession+numSession) = std(firstLickTime(totTargets));
    ipsi_rtVar(nSession+numSession)   = std(firstLickTime(~totTargets));    
end

figure;
subplot(1, 2, 1)
hold on
scatter(contra_rtVar, contra_corr, [], explainedCRR, 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Contra')
box off

subplot(1, 2, 2)
hold on
scatter(ipsi_rtVar, ipsi_corr, [], explainedCRR, 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Ipsi')
box off

setPrint(8*2, 6, 'Plots/ReactionTimeVar_TLDSScore')

figure
hold on
scatter(ipsi_corr, contra_corr, [], explainedCRR, 'filled')
colorbar
plot([-0.4 0.4], [0 0], '--k')
plot([0 0], [-0.4 0.4], '--k')
xlabel('Ipsi rank correlation RT-TLDS')
ylabel('Contra rank correlation RT-TLDS')
box off
setPrint(8, 6, 'Plots/ContraIpsi_TLDSScore')
