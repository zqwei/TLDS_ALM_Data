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
contra_corr  = nan(numSession, 3);
ipsi_corr    = nan(numSession, 3);
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
    [err, ~, ~] = loo (Y, Ph, [0, timePoint, T]);
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
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
    
    [contra_corr(nSession,1), ~, contra_corr(nSession,2), contra_corr(nSession,3)] =  ...
        corr_mode(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'Spearman');
    [ipsi_corr(nSession,1), ~, ipsi_corr(nSession,2), ipsi_corr(nSession,3)] =  ...
        corr_mode(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'Spearman');
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
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];


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
    [err, ~, ~] = loo (Y, Ph, [0, timePoint, T]);
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
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

    [contra_corr(nSession+numSession,1), ~, contra_corr(nSession+numSession,2), contra_corr(nSession+numSession,3)] =  ...
        corr_mode(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'Spearman');
    [ipsi_corr(nSession+numSession,1), ~, ipsi_corr(nSession+numSession,2), ipsi_corr(nSession+numSession,3)] =  ...
        corr_mode(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'Spearman');
    
%     contra_corr(nSession+numSession)  = corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman');
%     ipsi_corr(nSession+numSession)    = corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman');
    contra_rtVar(nSession+numSession) = std(firstLickTime(totTargets));
    ipsi_rtVar(nSession+numSession)   = std(firstLickTime(~totTargets));    
end

contStd = (contra_corr(:,3) - contra_corr(:,2))/2;
ipsiStd = (ipsi_corr(:,3) - ipsi_corr(:,2))/2;

filledStd = abs(contra_corr(:,1)) > contStd; 
figure;
subplot(1, 2, 1)
hold on
scatter(contra_rtVar(~filledStd), contra_corr(~filledStd,1), [], explainedCRR(~filledStd))
scatter(contra_rtVar(filledStd), contra_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Contra')
box off
set(gca, 'TickDir', 'out')

filledStd = abs(ipsi_corr(:,1)) > ipsiStd; 
subplot(1, 2, 2)
hold on
scatter(ipsi_rtVar(~filledStd), ipsi_corr(~filledStd,1), [], explainedCRR(~filledStd))
scatter(ipsi_rtVar(filledStd), ipsi_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Ipsi')
box off
set(gca, 'TickDir', 'out')
setPrint(8*2, 6, 'Plots/ReactionTimeVar_TLDSScore', 'pdf')

figure
hold on
contStd = (contra_corr(:,3) - contra_corr(:,2))/2;
ipsiStd = (ipsi_corr(:,3) - ipsi_corr(:,2))/2;
filledStd = abs(contra_corr(:,1)) > contStd | abs(ipsi_corr(:,1)) > ipsiStd; 

% ploterr(ipsi_corr(:,1), contra_corr(:,1), {ipsi_corr(:,2),ipsi_corr(:,3)}, {contra_corr(:,2),contra_corr(:,3)}, '.k')
scatter(ipsi_corr(filledStd,1), contra_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
scatter(ipsi_corr(~filledStd,1), contra_corr(~filledStd,1), [], explainedCRR(~filledStd))
% colorbar
plot([-0.5 0.5], [0 0], '--k')
plot([0 0], [-0.5 0.5], '--k')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
xlabel('Ipsi rank correlation RT-TLDS')
ylabel('Contra rank correlation RT-TLDS')
box off
set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/ContraIpsi_TLDSScore_err')
setPrint(8, 6, 'Plots/ContraIpsi_TLDSScore', 'pdf')
