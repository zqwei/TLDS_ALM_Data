addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

analysisIndex = [1:8 18 26:41];

load([TempDatDir 'Combined_Simultaneous_Error_Spikes_LOO.mat'])
errDataSet   = nDataSet(analysisIndex);
load([TempDatDir 'Combined_Simultaneous_Spikes_LOO.mat'])
corrDataSet  = nDataSet(analysisIndex);

numTime           = size(corrDataSet(1).unit_yes_trial, 3);

sigma                         = 0.1 / params.binsize; % 300 ms
filterLength                  = 11;
filterStep                    = linspace(-filterLength / 2, filterLength / 2, filterLength);
filterInUse                   = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
filterInUse                   = filterInUse / sum (filterInUse); 
% explainedCRR = [0.0941971391500324;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190327;0.107332573346359;0.557599484041760;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241]; % from EV_correct_error.m

correctRateTLDS   = nan(length(corrDataSet) - 1, numTime);
correctRateRaw    = nan(length(corrDataSet) - 1, numTime);


for nSession      = 1:length(corrDataSet)   
    % SAS space
    nSessionData  = [corrDataSet(nSession).unit_yes_fit; corrDataSet(nSession).unit_no_fit];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_fit; errDataSet(nSession).unit_no_fit];
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];
    nSessionData  = normalizationDim(nSessionData, 2);
    correctRate   = coeffSVM(nSessionData, totTargets); 
    correctRate   = correctRate(1,:);
    correctRate   = getGaussianPSTH(filterInUse, correctRate(1,:),2);
    correctRateTLDS(nSession, :) = correctRate;

    % Neural space
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    correctRate   = coeffSVM(nSessionData, totTargets); 
    correctRate   = correctRate(1,:);
    correctRate   = getGaussianPSTH(filterInUse, correctRate(1,:),2);
    correctRateRaw(nSession, :) = correctRate;
end

correctRateThres  = 0.65;
timePoint         = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
minCurrTime       = timePoint(2);
maxCurrTime       = numTime;
corrTimeTLDS      = nan(size(correctRateTLDS, 1),1);
corrTimeRaw       = nan(size(correctRateTLDS, 1),1);

for nSession      = 1:size(correctRateTLDS, 1)
    corrTimeTLDS(nSession) = getThresTime(correctRateTLDS(nSession, :), correctRateThres, minCurrTime, maxCurrTime);
    corrTimeRaw(nSession)  = getThresTime(correctRateRaw(nSession, :), correctRateThres, minCurrTime, maxCurrTime);
end

figure;
subplot(1,3,1)
hold on
% scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS), [], explainedCRR, 'filled')
scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS))
plot([-2.6 2.01],[-2.6 2.01], '--k')
xlim([-2.6 2.01]);
ylim([-2.6 2.01]);
set(gca, 'XTick', [-2.6 -1.3 0 2.0], 'YTick', [-2.6 -1.3 0 2.0])
set(gca, 'TickDir', 'out')
box off
xlabel('Correctness signal time (s)')
ylabel('Correctness signal time (s)')

subplot(1,3,2)
xCount = histcounts(params.timeSeries(corrTimeTLDS), [-2.6 -1.3 0 2.01]);
disp(xCount)
pie(xCount)

subplot(1,3,3)
xCount = histcounts(params.timeSeries(corrTimeRaw), [-2.6 -1.3 0 2.01]);
disp(xCount)
pie(xCount)

setPrint(8*3, 6, 'Plots/Correctness_signal_time')



figure;
subplot(1,3,1)
hold on
% scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS), [], explainedCRR, 'filled')
scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS))
plot([-2.6 2.1],[-2.6 2.1], '--k')
xlim([-2.6 2.1]);
ylim([-2.6 2.1]);
set(gca, 'XTick', [-2.6 -1.3 0 2.0], 'YTick', [-2.6 -1.3 0 2.0])
set(gca, 'TickDir', 'out')
box off
xlabel('Correctness signal time (s)')
ylabel('Correctness signal time (s)')

subplot(1,3,2)
xCount = histcounts(params.timeSeries(corrTimeTLDS), [-2.6 -1.3 0 1.9 2.1]);
disp(xCount)
pie(xCount)

subplot(1,3,3)
xCount = histcounts(params.timeSeries(corrTimeRaw), [-2.6 -1.3 0 1.9 2.1]);
disp(xCount)
pie(xCount)

setPrint(8*3, 6, 'Plots/Correctness_signal_time')

fns_corr_rate    = nan(length(corrDataSet), 2);
tlds_corr_rate   = nan(length(corrDataSet), 2);
per_corr_trial   = nan(length(corrDataSet), 1);

numTimePoints    = 4;

for nSession  = 1:length(corrDataSet)
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];    
    per_corr_trial(nSession) = mean(totTargets);
    
    fns_corr_rate(nSession, 1) = mean(correctRateRaw(nSession, timePoint(4)-numTimePoints:timePoint(4)));
    fns_corr_rate(nSession, 2) = std(correctRateRaw(nSession, timePoint(4)-numTimePoints:timePoint(4)))/sqrt(numTimePoints+1);
    
    tlds_corr_rate(nSession, 1) = mean(correctRateTLDS(nSession, timePoint(4)-numTimePoints:timePoint(4)));
    tlds_corr_rate(nSession, 2) = std(correctRateTLDS(nSession, timePoint(4)-numTimePoints:timePoint(4)))/sqrt(numTimePoints+1);
    
end

figure;
hold on
plot([0.5 1], [0.5 1], '--k')
% ploterr(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
% scatter(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, [], per_corr_trial', 'filled')
ploterr(fns_corr_rate(:,1), tlds_corr_rate(:,1), fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
% scatter(fns_corr_rate(:,1), tlds_corr_rate(:,1), [], per_corr_trial', 'filled')
scatter(fns_corr_rate(:,1), tlds_corr_rate(:,1))
xlim([0.5 0.82])
ylim([0.5 0.82])
xlabel('Correctness LDA')
ylabel('Correctness TLDS')
set(gca, 'TickDir', 'out')
box off
setPrint(8, 6, 'Plots/Correctness_TLDS_Comparison')
