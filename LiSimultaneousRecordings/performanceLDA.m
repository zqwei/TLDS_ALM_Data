addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])

timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];
TLDS_decode  = nan(numSession, 2);
LDA_decode   = nan(numSession, 2);
explainedCRR = nan(numSession, 1);
kFold        = 10;


for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    m          = ceil(yDim/4)*2;
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    neuroMat   = squeeze(Y(:, timePoint(end), :));
    
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat', totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    LDA_decode(nSession,1) = mean(L);
    LDA_decode(nSession,2) = std(L)/sqrt(kFold);
    
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
    
    neuroMat   = scoreMat(:, timePoint(end));
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat, totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    TLDS_decode(nSession,1) = mean(L);
    TLDS_decode(nSession,2) = std(L)/sqrt(kFold);
    
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
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    neuroMat   = squeeze(Y(:, timePoint(end), :));
    
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat', totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    LDA_decode(nSession+numSession,1) = mean(L);
    LDA_decode(nSession+numSession,2) = std(L)/sqrt(kFold);
    
    
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
    
    neuroMat   = scoreMat(:, timePoint(end));
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat, totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    TLDS_decode(nSession+numSession,1) = mean(L);
    TLDS_decode(nSession+numSession,2) = std(L)/sqrt(kFold);

end



figure
hold on
ploterr(LDA_decode(:,1), TLDS_decode(:,1), LDA_decode(:,2), TLDS_decode(:,2), '.k')
scatter(LDA_decode(:,1), TLDS_decode(:,1), [], explainedCRR, 'filled')
% colorbar
plot([0.5 1], [0.5 1], '--k')
xlim([0.5 1])
ylim([0.5 1])
xlabel('Performance LDA')
ylabel('Performance TLDS')
set(gca, 'TickDir', 'out')
box off
setPrint(8, 6, 'Plots/Performance_TLDSScore')
