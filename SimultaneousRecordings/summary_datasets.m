addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
errDataSet   = nDataSet;
load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])


numSession   = length(nDataSet);
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
    if ~isempty(errDataSet(nSession).unit_yes_trial)
        fireRate(nSession, 5)  = min(mean(mean(errDataSet(nSession).unit_yes_trial, 3), 1));
        fireRate(nSession, 6)  = max(mean(mean(errDataSet(nSession).unit_yes_trial, 3), 1));
    end
    numNoError(nSession)   = sum(~errDataSet(nSession).totTargets);
    if ~isempty(errDataSet(nSession).unit_no_trial)
        fireRate(nSession, 7)  = min(mean(mean(errDataSet(nSession).unit_no_trial, 3), 1));
        fireRate(nSession, 8)  = max(mean(mean(errDataSet(nSession).unit_no_trial, 3), 1));
    end
end

summary_table = [(1:numSession)', numUnits, numYesTrial, numNoTrial, numYesError, numNoError, fireRate];
% summary_table = [(1:numSession)', numUnits, fireRate];
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
    numXDim(nSession)      = size(nDataSet(nSession).KFPh.A, 1);
    A                      = nDataSet(nSession).KFPh.A;
    for nA                 = 1:4
        EigA(nSession, nA) = max(abs(eig(squeeze(A(:,:,nA)))));
    end
end

sum_pair = 0;
for nData = 1:length(nDataSet)
    disp('--------------------------------')
    disp(['Session #' num2str(nData)])
    diff_trial = diff(nDataSet(nData).unit_yes_trial_index);
    diff_trial_yes = find(diff_trial == 1);
    if size(diff_trial_yes, 1)>1; diff_trial_yes = diff_trial_yes'; end
    for n_trial = diff_trial_yes
        disp(['Yes trial pair: ' num2str(nDataSet(nData).unit_yes_trial_index(n_trial)) ' and ' num2str(nDataSet(nData).unit_yes_trial_index(n_trial+1))])
        sum_pair = sum_pair + 1;
    end
    diff_trial = diff(nDataSet(nData).unit_no_trial_index);
    diff_trial_no = find(diff_trial == 1);
    if size(diff_trial_no, 1)>1; diff_trial_no = diff_trial_no'; end
    for n_trial = diff_trial_no
        disp(['No trial pair: ' num2str(nDataSet(nData).unit_no_trial_index(n_trial)) ' and ' num2str(nDataSet(nData).unit_no_trial_index(n_trial+1))])
        sum_pair = sum_pair + 1;
    end
end

figure;
EigA_ = EigA;
EigA_(:,1) = EigA_(:,1)-0.1;
timeA = 0.0674./(1-EigA_);
timeA(timeA<0) = max(timeA(:));
timeA(timeA>20) = 20;
for nEpoch = 1:4
    subplot(1, 4, nEpoch)
    hist(timeA(:, nEpoch), 0:2.5:20)
    xlabel('Time constant (sec)')
    ylabel('# sessions')
    ylim([0 52])
    xlim([-2 23])
    box off
    set(gca, 'TickDir', 'out')
end
setPrint(8*4, 6, 'Plots/Time_constant', 'pdf')