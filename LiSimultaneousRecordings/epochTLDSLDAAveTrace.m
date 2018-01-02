addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'SimultaneousError_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27, 9,11, 9,30,13,11,30,25,11, 9,30,22, 1,15];
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

nSession   = 17;

Y          = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
numYesTrial = size(corrDataSet(nSession).unit_yes_trial, 1);
numNoTrial  = size(corrDataSet(nSession).unit_no_trial, 1);
numTrials   = numYesTrial + numNoTrial;
Y          = permute(Y, [2 3 1]);
T          = size(Y, 2);
xDim       = xDimSet(nSession);
optFit     = optFitSet(nSession);
load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
[~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
nSessionData  = permute(y_est, [3 1 2]);
nSessionData  = normalizationDim(nSessionData, 2);  
coeffs        = coeffLDA(nSessionData, totTargets);
scoreMat      = nan(numTrials, size(nSessionData, 3));
mean_scoreMat = nan(1, size(nSessionData, 3));
for nTime     = 1:size(nSessionData, 3)
    tscoreMat = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    scoreMat(:, nTime) = tscoreMat - mean(tscoreMat);
    mean_scoreMat(:, nTime) = mean(tscoreMat);
end

simCorrMat    = corr(scoreMat, 'type', 'Spearman');

figure;
hold on
shadedErrorBar(params.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets)), {'-b'},0.7)
shadedErrorBar(params.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :))/sqrt(sum(~totTargets)), {'-r'},0.7)

Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
numTrials   = numYesTrial + numNoTrial;
Y          = permute(Y, [2 3 1]);
yDim       = size(Y, 1);
T          = size(Y, 2);
    
xDim       = xDimSet(nSession);
optFit     = optFitSet(nSession);
load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
[~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);


totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
nSessionData  = permute(y_est, [3 1 2]);
nSessionData  = normalizationDim(nSessionData, 2);  
scoreMat      = nan(numTrials, size(nSessionData, 3));
for nTime     = 1:size(nSessionData, 3)
    scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % mean_scoreMat(:, nTime);%
end

simErrMat    = corr(scoreMat, 'type', 'Spearman');

shadedErrorBar(params.timeSeries, mean(scoreMat(totTargets, :)), std(scoreMat(totTargets, :))/sqrt(sum(totTargets)), {'-b'}, 0.3)
shadedErrorBar(params.timeSeries, mean(scoreMat(~totTargets, :)), std(scoreMat(~totTargets, :))/sqrt(sum(~totTargets)), {'-r'}, 0.3)

gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
xlim([min(params.timeSeries) max(params.timeSeries)]);
box off
hold off
xlabel('Time (s)')
ylabel('LDA score')
set(gca, 'TickDir', 'out')
setPrint(8, 6, ['Plots/TLDSLDASimilarityErrorSesssionCorrectLDAAve_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])


figure
hold on
shadedErrorBar(params.timeSeries, mean(simCorrMat(timePoint(2)+(-5:0), :)), std(simCorrMat(timePoint(2)+(-5:0), :))/sqrt(sum(6)), {'-m'})
shadedErrorBar(params.timeSeries, abs(mean(simErrMat(timePoint(2)+(-5:0), :))), std(simErrMat(timePoint(2)+(-5:0), :))/sqrt(sum(6)), {'-g'})
gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
xlim([min(params.timeSeries) max(params.timeSeries)]);
ylim([0 1])
box off
hold off
xlabel('Time (s)')
ylabel('LDA score')
set(gca, 'TickDir', 'out')
setPrint(8, 6, ['Plots/TLDSCorrectness_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])

