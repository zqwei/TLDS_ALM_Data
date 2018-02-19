addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSoundSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
numFolds        = 10;

for nSession = 1:numSession
    % Y = trial x nUnit x nTime
    Y           = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    totTargets  = [true(numYesTrial, 1); false(numNoTrial, 1)];
    dat         = getGPFAData(Y, totTargets);
    for xDim = 1:size(Y, 2)-2
      neuralTraj(nSession, dat, 'method',  'pca', 'xDim', xDim, 'numFolds', numFolds);
      neuralTraj(nSession, dat, 'method', 'ppca', 'xDim', xDim, 'numFolds', numFolds);
      neuralTraj(nSession, dat, 'method',   'fa', 'xDim', xDim, 'numFolds', numFolds);
      neuralTraj(nSession, dat, 'method', 'gpfa', 'xDim', xDim, 'numFolds', numFolds);
    end
end