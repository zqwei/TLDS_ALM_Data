addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;

% load([TempDatDir 'Combined_Simultaneous_Error_Spikes.mat'])
% errDataSet   = nDataSet;
% load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
% corrDataSet  = nDataSet;
% load([TempDatDir 'Combined_data_SLDS_Error_fit.mat'], 'fitErrData')
% load([TempDatDir 'Combined_data_SLDS_fit.mat'], 'fitData')

% numTime           = size(corrDataSet(1).unit_yes_trial, 3);

% sigma                         = 0.1 / params(1).binsize; % 300 ms
% filterLength                  = 11;
% filterStep                    = linspace(-filterLength / 2, filterLength / 2, filterLength);
% filterInUse                   = exp(-filterStep .^ 2 / (2 * sigma ^ 2));
% filterInUse                   = filterInUse / sum (filterInUse); 
% 
% correctRateTLDS   = nan(length(corrDataSet) - 1, numTime);
correctRateRaw    = nan(length(corrDataSet) - 1, numTime);


for nSession      = 1:length(corrDataSet)   
    if ~isempty(errDataSet(nSession).unit_yes_trial) && ~isempty(errDataSet(nSession).unit_no_trial)
        % SAS space
%         nSessionData  = [corrDataSet(nSession).unit_KF_yes_fit; corrDataSet(nSession).unit_KF_no_fit];
%         nSessionData  = [nSessionData; errDataSet(nSession).unit_KF_yes_fit; errDataSet(nSession).unit_KF_no_fit];
        totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
        totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];
%         nSessionData  = normalizationDim(nSessionData, 2);
%         correctRate   = coeffSVM(nSessionData, totTargets); 
%         correctRate   = correctRate(1,:);
%         correctRate   = getGaussianPSTH(filterInUse, correctRate(1,:),2);
%         correctRateTLDS(nSession, :) = correctRate;

        % Neural space
%         nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
%         nSessionData  = [nSessionData; errDataSet(nSession).unit_yes_trial; errDataSet(nSession).unit_no_trial];
%         nSessionData  = [corrDataSet(nSession).unit_KFFoward_yes_fit; corrDataSet(nSession).unit_KFFoward_no_fit];
%         nSessionData  = [nSessionData; errDataSet(nSession).unit_KFFoward_yes_fit; errDataSet(nSession).unit_KFFoward_no_fit];
        nSessionData  = [fitData(nSession).K8yEst; fitErrData(nSession).K8yEst];
        nSessionData  = normalizationDim(nSessionData, 2);  
        correctRate   = coeffSVM(nSessionData, totTargets); 
        correctRate   = correctRate(1,:);
        correctRate   = getGaussianPSTH(filterInUse, correctRate(1,:),2);
        correctRateRaw(nSession, :) = correctRate;
    end
end

correctRateRawPre = mean(correctRateRaw(:, 1:8), 2);
correctRateRaw_    = bsxfun(@minus, correctRateRaw, max(correctRateRawPre-0.5, 0));
% correctRateRaw_    = correctRateRaw;
correctRateThres  = 0.65;
% corrTimeTLDS      = nan(size(correctRateTLDS, 1),1);
corrTimeRaw       = nan(size(correctRateTLDS, 1),1);
% corrTimeTLDS_     = nan(size(correctRateTLDS, 1),1);
corrTimeRaw_      = nan(size(correctRateTLDS, 1),1);

for nSession      = 1:size(correctRateTLDS, 1)
    param             = params(corrDataSet(nSession).task_type);
    timePoint         = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    minCurrTime       = timePoint(2);
    maxCurrTime       = numTime;
%     corrTimeTLDS(nSession) = getThresTime(correctRateTLDS(nSession, :), correctRateThres, minCurrTime, maxCurrTime);
    corrTimeRaw(nSession)  = getThresTime(correctRateRaw_(nSession, :), correctRateThres, minCurrTime, maxCurrTime);
%     corrTimeTLDS_(nSession) = param.timeSeries(corrTimeTLDS(nSession));
    corrTimeRaw_(nSession)  = min(param.timeSeries(corrTimeRaw(nSession)), 2);
end

figure;
% subplot(1,3,1)
hold on
% scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS), [], explainedCRR, 'filled')
% scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS))
plot(corrTimeRaw_(1:40), corrTimeTLDS_(1:40), 'ok')
plot(corrTimeRaw_(41:55), corrTimeTLDS_(41:55), 'ob')
[p, h] = signrank(corrTimeRaw_, corrTimeTLDS_)
plot([-3.0 2.01],[-3.0 2.01], '--k')
xlim([-3.0 2.01]);
ylim([-3.0 2.01]);
set(gca, 'XTick', [-2.0 -1.3 0 2.0], 'YTick', [-2.0 -1.3 0 2.0])
set(gca, 'TickDir', 'out')
box off
xlabel('Correctness signal time (s)')
ylabel('Correctness signal time (s)')
setPrint(8, 6, 'Plots/Correctness_signal_time')

% subplot(1,3,2)
% xCount = histcounts(corrTimeTLDS_, [-2.6 -1.3 0 2.01]);
% disp(xCount)
% pie(xCount)
% 
% subplot(1,3,3)
% xCount = histcounts(corrTimeRaw_, [-2.6 -1.3 0 2.01]);
% disp(xCount)
% pie(xCount)
% 
% setPrint(8*3, 6, 'Plots/Correctness_signal_time')



% % % figure;
% % % subplot(1,3,1)
% % % hold on
% % % % scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS), [], explainedCRR, 'filled')
% % % scatter(params.timeSeries(corrTimeRaw), params.timeSeries(corrTimeTLDS))
% % % plot([-2.6 2.1],[-2.6 2.1], '--k')
% % % xlim([-2.6 2.1]);
% % % ylim([-2.6 2.1]);
% % % set(gca, 'XTick', [-2.6 -1.3 0 2.0], 'YTick', [-2.6 -1.3 0 2.0])
% % % set(gca, 'TickDir', 'out')
% % % box off
% % % xlabel('Correctness signal time (s)')
% % % ylabel('Correctness signal time (s)')
% % % 
% % % subplot(1,3,2)
% % % xCount = histcounts(params.timeSeries(corrTimeTLDS), [-2.6 -1.3 0 1.9 2.1]);
% % % disp(xCount)
% % % pie(xCount)
% % % 
% % % subplot(1,3,3)
% % % xCount = histcounts(params.timeSeries(corrTimeRaw), [-2.6 -1.3 0 1.9 2.1]);
% % % disp(xCount)
% % % pie(xCount)
% % % 
% % % setPrint(8*3, 6, 'Plots/Correctness_signal_time')
% % % 
fns_corr_rate    = nan(length(corrDataSet), 2);
% tlds_corr_rate   = nan(length(corrDataSet), 2);
per_corr_trial   = nan(length(corrDataSet), 1);

numTimePoints    = 4;

for nSession  = 1:length(corrDataSet)
    totTargets    = true(length(corrDataSet(nSession).totTargets), 1);
    totTargets    = [totTargets; false(length(errDataSet(nSession).totTargets), 1)];    
    per_corr_trial(nSession) = mean(totTargets);
    
    fns_corr_rate(nSession, 1) = mean(correctRateRaw_(nSession, timePoint(4)-numTimePoints:timePoint(4)));
    fns_corr_rate(nSession, 2) = std(correctRateRaw_(nSession, timePoint(4)-numTimePoints:timePoint(4)))/sqrt(numTimePoints+1);
    
%     tlds_corr_rate(nSession, 1) = mean(correctRateTLDS(nSession, timePoint(4)-numTimePoints:timePoint(4)));
%     tlds_corr_rate(nSession, 2) = std(correctRateTLDS(nSession, timePoint(4)-numTimePoints:timePoint(4)))/sqrt(numTimePoints+1);
    
end

figure;
hold on
plot([0.5 1], [0.5 1], '--k')
% ploterr(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
% scatter(fns_corr_rate(:,1)-per_corr_trial, tlds_corr_rate(:,1)-per_corr_trial, [], per_corr_trial', 'filled')
% ploterr(fns_corr_rate(:,1), tlds_corr_rate(:,1), fns_corr_rate(:,2), tlds_corr_rate(:,2), '.k')
% scatter(fns_corr_rate(:,1), tlds_corr_rate(:,1), [], per_corr_trial', 'filled')
plot(fns_corr_rate(:,1), tlds_corr_rate(:,1), 'ok')
[p, h] = signrank(fns_corr_rate(:,1), tlds_corr_rate(:,1))
xlim([0.5 1.01])
ylim([0.5 1.01])
xlabel('Correctness LDA')
ylabel('Correctness TLDS')
set(gca, 'xTick', 0.5:0.1:1)
set(gca, 'yTick', 0.5:0.1:1)
set(gca, 'TickDir', 'out')
box off
setPrint(8, 6, 'Plots/Correctness_TLDS_Comparison')
