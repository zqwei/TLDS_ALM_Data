addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_Spikes.mat'])
numSession   = length(nDataSet);

GPFA_err     = nan(numSession, 1);
for nSession = 1:numSession    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
    y_est = nan(size(Y));
    for nTrial = 1:size(Y, 3)
        y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
        y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
        y_est_nTrial (y_est_nTrial <0) = 0;
        y_est_nTrial = y_est_nTrial.^2;
        y_est(:, :, nTrial) = y_est_nTrial;
    end    
    mean_Y     = mean(mean(Y, 3), 2);
    rand_y     = bsxfun(@minus, Y, mean_Y);
    err        = sum((Y(:) - y_est(:)).^2)/ sum(rand_y(:).^2);
    GPFA_err(nSession) = 1 - err;
end


load([TempDatDir 'Simultaneous_HiSpikes.mat'])

for nSession = 1:length(nDataSet)    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    yesTrial   = size(nDataSet(nSession).unit_yes_trial, 1);
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    load(['../HidehikoRecordings/GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
    y_est = nan(size(Y));
    for nTrial = 1:size(Y, 3)
        y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
        y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
        y_est_nTrial (y_est_nTrial <0) = 0;
        y_est_nTrial = y_est_nTrial.^2;
        y_est(:, :, nTrial) = y_est_nTrial;
    end    
    mean_Y     = mean(mean(Y, 3), 2);
    rand_y     = bsxfun(@minus, Y, mean_Y);
    err        = sum((Y(:) - y_est(:)).^2)/ sum(rand_y(:).^2);
    GPFA_err(nSession+numSession) = 1 - err;
end


TLDS_err = [.09, .22, .13, .20, .36, .08, .11, .56, .13, .14, .42, .18, .29, .36, .47, .41, .37, .44, .36];

figure
hold on
plot(GPFA_err, TLDS_err, 'ok')
plot([-.1 .6], [-.1 .6], '--k')
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'GPFA_EV')