addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

numSession   = length(nDataSet) - 1;
numYesTrial  = nan(numSession, 1);
numNoTrial   = nan(numSession, 1);
numYesError  = nan(numSession, 1);
numNoError   = nan(numSession, 1);

for nSession = 1:numSession
    numYesTrial(nSession)  = sum(nDataSet(nSession).totTargets);
    numNoTrial(nSession)   = sum(~nDataSet(nSession).totTargets);
    numYesError(nSession)  = sum(errDataSet(nSession).totTargets);
    numNoError(nSession)   = sum(~errDataSet(nSession).totTargets);
end

% [(1:numSession)', numYesTrial, numNoTrial, numYesError, numNoError]



