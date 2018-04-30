addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

numShfTrials = 200;

load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [2, 3, 4, 2, 4, 2, 4, 3, 5, 3, 4, 5, 5, 6, 5, 5, 4, 4, 3, 3, 4, 6];
optFitSet    = [6,10,11,10,30,18,19,27, 9,11, 9,30,13,11,30,25,11, 9,30,22, 1,15];
optFitSetAC  = [6,29,20,14,17,11,20,18,11,25,22,30,20, 6,15, 9,30,22,30,29,21, 3];

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
%     optFit     = optFitSet(nSession);
%     load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    optFit     = optFitSetAC(nSession);
    load ([TempDatDir 'SessionConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');

    % KF filter
    nDataSet(nSession).Ph  = Ph;
    nDataSet(nSession).task_type = 1;
%     [x_est, y_est] = loo(Y, Ph, [0, timePoint, T]);
    [~, y_est] = loo(Y, Ph, [0 T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_KF_yes_fit = y_est(1:numYesTrial, :, :);
    nDataSet(nSession).unit_KF_no_fit  = y_est(1+numYesTrial:end, :, :);
    % Shuffle KF filter
    Y_shuffle  = shuffleSession(nDataSet(nSession), numShfTrials);
    nDataSet(nSession).unit_yes_Shftrial = Y_shuffle(1:numShfTrials, :, :);
    nDataSet(nSession).unit_no_Shftrial = Y_shuffle(1+numShfTrials:end, :, :);
    Y_shuffle  = permute(Y_shuffle, [2 3 1]); % unit x time x trial
%     [~, y_est] = loo(Y_shuffle, Ph, [0, timePoint, T]);
    [~, y_est] = loo(Y_shuffle, Ph, [0 T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_KFShf_yes_fit = y_est(1:numShfTrials, :, :);
    nDataSet(nSession).unit_KFShf_no_fit  = y_est(1+numShfTrials:end, :, :);    
end

nDataSetOld    = nDataSet;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSessionHi   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
optFitSetAC  = [2, 18, 9, 8, 6, 12, 11, 12, 24, 23, 13, 27, 24, 16, 23, 13, 27, 14];


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
%     optFit     = optFitSet(nSession);
%     load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');

    optFit     = optFitSetAC(nSession);
    load ([TempDatDir 'SessionHiConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');

    % KF filter
    nDataSet(nSession).Ph  = Ph;
    nDataSet(nSession).task_type = 1;
%     [x_est, y_est] = loo(Y, Ph, [0, timePoint, T]);
    [~, y_est] = loo(Y, Ph, [0 T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_KF_yes_fit = y_est(1:numYesTrial, :, :);
    nDataSet(nSession).unit_KF_no_fit  = y_est(1+numYesTrial:end, :, :);
    % Shuffle KF filter
    Y_shuffle  = shuffleSession(nDataSet(nSession), numShfTrials);
    nDataSet(nSession).unit_yes_Shftrial = Y_shuffle(1:numShfTrials, :, :);
    nDataSet(nSession).unit_no_Shftrial = Y_shuffle(1+numShfTrials:end, :, :);
    Y_shuffle  = permute(Y_shuffle, [2 3 1]); % unit x time x trial
%     [~, y_est] = loo(Y_shuffle, Ph, [0, timePoint, T]);
    [~, y_est] = loo(Y_shuffle, Ph, [0 T]);
    y_est      = permute(y_est, [3 1 2]); % trial x unit x time
    nDataSet(nSession).unit_KFShf_yes_fit = y_est(1:numShfTrials, :, :);
    nDataSet(nSession).unit_KFShf_no_fit  = y_est(1+numShfTrials:end, :, :);   
end

nDataSetOld    = [nDataSetOld'; nDataSet'];
paramsOld      = params;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
params.timeSeries = params.timeSeries(params.timeSeries < 1.5);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSessionSound   = length(nDataSet);
xDimSet      = [ 5, 6, 4, 6, 4, 6, 4, 6, 3, 8, 8, 0, 8, 6, 6, 7];
optFitSet    = [18,21,27,23, 2, 6, 9, 9,19, 3,29, 0,27,29,30,11];
optFitSetAC  = [12,13,28,2,25,12,27,26,3,2,3,NaN,20,17,7,25];

for nSession = 1:numSessionSound
    nDataSet(nSession).unit_yes_trial = nDataSet(nSession).unit_yes_trial(:, :, 1:length(params.timeSeries));
    nDataSet(nSession).unit_no_trial  = nDataSet(nSession).unit_no_trial(:, :, 1:length(params.timeSeries));
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
    if optFit>0
%         load ([TempDatDir 'SessionHiSound_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
        optFit     = optFitSetAC(nSession);
        load ([TempDatDir 'SessionHiSoundConstantAC_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');

        % KF filter
        nDataSet(nSession).Ph  = Ph;
        nDataSet(nSession).task_type = 2;
%         [x_est, y_est] = loo(Y, Ph, [0, timePoint, T]);
        [~, y_est] = loo(Y, Ph, [0 T]);
        y_est      = permute(y_est, [3 1 2]); % trial x unit x time
        nDataSet(nSession).unit_KF_yes_fit = y_est(1:numYesTrial, :, :);
        nDataSet(nSession).unit_KF_no_fit  = y_est(1+numYesTrial:end, :, :);
        % Shuffle KF filter
        Y_shuffle  = shuffleSession(nDataSet(nSession), numShfTrials);
        nDataSet(nSession).unit_yes_Shftrial = Y_shuffle(1:numShfTrials, :, :);
        nDataSet(nSession).unit_no_Shftrial = Y_shuffle(1+numShfTrials:end, :, :);
        Y_shuffle  = permute(Y_shuffle, [2 3 1]); % unit x time x trial
%         [~, y_est] = loo(Y_shuffle, Ph, [0, timePoint, T]);
        [~, y_est] = loo(Y_shuffle, Ph, [0 T]);
        y_est      = permute(y_est, [3 1 2]); % trial x unit x time
        nDataSet(nSession).unit_KFShf_yes_fit = y_est(1:numShfTrials, :, :);
        nDataSet(nSession).unit_KFShf_no_fit  = y_est(1+numShfTrials:end, :, :);   
    end
end

nDataSet    = [nDataSetOld; nDataSet];
params      = [paramsOld, params];
removeList  = arrayfun(@(x) ~isempty(x.unit_KF_yes_fit), nDataSet);
nDataSet    = nDataSet(removeList);


save([TempDatDir 'Combined_Shuffle_Spikes.mat'], 'nDataSet', 'params')