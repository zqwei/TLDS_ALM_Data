addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])

timePoint         = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint         = timePoint(2:end-1);

fns_corr_rate    = nan(length(nDataSet), 2);
tlds_corr_rate   = nan(length(nDataSet), 2);
per_corr_trial   = nan(length(nDataSet), 1);

for nSession  = 1:length(nDataSet) - 1
    numYesTrial   = length(corrDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(corrDataSet(nSession).unit_no_trial_index);
    totTargets    = true(numYesTrial+numNoTrial, 1);
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [totTargets; false(numYesTrial+numNoTrial, 1)];
    
    per_corr_trial(nSession) = mean(totTargets);
    
    nSessionData  = [nSessionData; nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    [~, ~, ~, correctRate] = coeffSLDA(nSessionData, totTargets);
    
    correctRate   = mean(correctRate(timePoint(end)-5:timePoint(end)));
    
    fns_corr_rate(nSession, 1) = correctRate;
    fns_corr_rate(nSession, 2) = sqrt(correctRate.*(1-correctRate)/length(totTargets));
    
    nSessionData  = [corrDataSet(nSession).unit_yes_fit; corrDataSet(nSession).unit_no_fit];    
    nSessionData  = [nSessionData; nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    [~, ~, ~, correctRate] = coeffSLDA(nSessionData, totTargets);
    
    correctRate   = mean(correctRate(timePoint(end)-3:timePoint(end)));
    
    tlds_corr_rate(nSession, 1) = correctRate;
    tlds_corr_rate(nSession, 2) = sqrt(correctRate.*(1-correctRate)/length(totTargets));
    
end

figure;
hold on
plot([0.5 1], [0.5 1], '--k')
% ploterr(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
% scatter(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, [], per_corr_trial', 'filled')
ploterr(fns_corr_rate(:,1), tlds_corr_rate(:,1), fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
scatter(fns_corr_rate(:,1), tlds_corr_rate(:,1), [], per_corr_trial', 'filled')
xlim([0.5 1.001])
ylim([0.5 1.001])
xlabel('Correctness LDA')
ylabel('Correctness TLDS')
set(gca, 'TickDir', 'out')
box off
setPrint(8, 6, 'Plots/Correctness_TLDS_Comparison')
