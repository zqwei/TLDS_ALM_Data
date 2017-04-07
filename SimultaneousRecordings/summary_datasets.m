addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])


numSession   = length(nDataSet) - 1;
numUnits     = nan(numSession, 1);
numYesTrial  = nan(numSession, 1);
numNoTrial   = nan(numSession, 1);
numYesError  = nan(numSession, 1);
numNoError   = nan(numSession, 1);
fireRate     = nan(numSession, 8);

for nSession = 1:numSession
    numUnits(nSession)      = length(nDataSet(nSession).nUnit);
    numYesTrial(nSession)  = sum(nDataSet(nSession).totTargets);
    fireRate(nSession, 1)  = min(mean(mean(nDataSet(nSession).unit_yes_trial, 3), 1));
    fireRate(nSession, 2)  = max(mean(mean(nDataSet(nSession).unit_yes_trial, 3), 1));
    numNoTrial(nSession)   = sum(~nDataSet(nSession).totTargets);
    fireRate(nSession, 3)  = min(mean(mean(nDataSet(nSession).unit_no_trial, 3), 1));
    fireRate(nSession, 4)  = max(mean(mean(nDataSet(nSession).unit_no_trial, 3), 1));
    numYesError(nSession)  = sum(errDataSet(nSession).totTargets);
    fireRate(nSession, 5)  = min(mean(mean(errDataSet(nSession).unit_yes_trial, 3), 1));
    fireRate(nSession, 6)  = max(mean(mean(errDataSet(nSession).unit_yes_trial, 3), 1));
    numNoError(nSession)   = sum(~errDataSet(nSession).totTargets);
    fireRate(nSession, 7)  = min(mean(mean(errDataSet(nSession).unit_no_trial, 3), 1));
    fireRate(nSession, 8)  = max(mean(mean(errDataSet(nSession).unit_no_trial, 3), 1));
end

% summary_table = [(1:numSession)', numUnits, numYesTrial, numNoTrial, numYesError, numNoError, fireRate];
summary_table = [(1:numSession)', numUnits, fireRate];
disp(summary_table)
excel_output  = cell(numSession, 4);


% excel table #1
for nSession  = 1:numSession
    for nCell = 1:4
        excel_output(nSession, nCell) = {[num2str(summary_table(nSession, 1+nCell*2), '%.2f') ' - ' num2str(summary_table(nSession, 2+nCell*2), '%.2f')]};
    end
end


% excel table #2
numXDim      = nan(numSession, 1);  
EigA         = nan(numSession, 3);
for nSession = 1:numSession
    numXDim(nSession)      = size(nDataSet(nSession).x_yes_fit, 2);
    A                      = nDataSet(nSession).Ph.A;
    for nA                 = 1:3
        EigA(nSession, nA) = max(abs(eig(squeeze(A(:,:,nA+1)))));
    end
end