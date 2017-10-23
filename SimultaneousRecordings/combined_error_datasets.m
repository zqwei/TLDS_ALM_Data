addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'SimultaneousError_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 3, 4, 4, 5, 6, 5, 4, 5, 4, 3, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27,27,28,14,4,20,9,14,24,5,8,18,22,1,12,5,12];

for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]); % unit x time x trial
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    m          = ceil(yDim/4)*2;    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    x_est      = permute(x_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_yes_fit = y_est(1:numYesTrial, :, :);
    nDataSet(nSession).unit_no_fit  = y_est(1+numYesTrial:end, :, :);
    nDataSet(nSession).x_yes_fit = x_est(1:numYesTrial, :, :);
    nDataSet(nSession).x_no_fit  = x_est(1+numYesTrial:end, :, :);
    nDataSet(nSession).Ph  = Ph;
end

nDataSetOld    = nDataSet;

load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSessionHi   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];

for nSession = 1:numSessionHi
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]); % unit x time x trial
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    m          = ceil(yDim/4)*2;    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    x_est      = permute(x_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_yes_fit = y_est(1:numYesTrial, :, :);
    nDataSet(nSession).unit_no_fit  = y_est(1+numYesTrial:end, :, :);
    nDataSet(nSession).x_yes_fit = x_est(1:numYesTrial, :, :);
    nDataSet(nSession).x_no_fit  = x_est(1+numYesTrial:end, :, :);
    nDataSet(nSession).Ph  = Ph;
end

nDataSet        = [nDataSetOld'; nDataSet'];
save([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'], 'nDataSet', 'params')