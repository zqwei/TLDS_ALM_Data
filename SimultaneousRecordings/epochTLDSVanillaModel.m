addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [ 2,  3,  4,  2,  4,  2,  4,  3];
optFitSet    = [ 6, 10, 11, 10, 30, 18, 19, 27];
explainedVRR = nan(numSession, 1); % vanilla model
explainedCRR = nan(numSession, 1);
numUints     = nan(numSession, 1);

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    noTrial    = size(nDataSet(nSession).unit_no_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    totTrial   = [true(yesTrial, 1); false(noTrial, 1)];
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, ~, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedCRR(nSession) = 1 - err;
    numUints(nSession)     = yDim;
    
    err        = evMean (Y, Ph, timePoint, totTrial);
    explainedVRR(nSession) = 1 - err;
    
end

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSessionHi = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3];
optFitSet    = [4, 25, 7, 20, 8];

for nSession = 1:numSessionHi
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    noTrial    = size(nDataSet(nSession).unit_no_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    totTrial   = [true(yesTrial, 1); false(noTrial, 1)];
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [err, ~, ~] = loo (Y, Ph, [0, timePoint, T]);
    explainedCRR(nSession+numSession) = 1 - err;
    numUints(nSession+numSession)     = yDim;
    
    err        = evMean (Y, Ph, timePoint, totTrial);
    explainedVRR(nSession+numSession) = 1 - err;
end

figure;
hold on
scatter(explainedCRR, explainedVRR, [], numUints, 'filled');
plot([-0.05 1], [-0.05 1], '--k');
colorbar
hold off
xlim([-0.05 0.6])
ylim([-0.05 0.6])
xlabel('EV TLDS model')
ylabel('EV Vanilla model')
setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect')
close all