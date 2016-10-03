addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])

% %% LDA
% timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
% timePoint    = timePoint(2:end-1);
% for nSession      = 1:length(nDataSet)
%     numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
%     numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
%     totTargets    = nDataSet(nSession).totTargets;
%     firstLickTime = nDataSet(nSession).firstLickTime;
%     numUnits      = length(nDataSet(nSession).nUnit);
%     numTrials     = numYesTrial + numNoTrial;
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = coeffLDA(nSessionData, totTargets);
%     scoreMat      = nan(numTrials, size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%     end
%     
%     figure;
%     subplot(1, 3, 1)
%     hold on
%     plot(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'ob')
%     plot(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'or')
%     box off
%     hold off
%     xlabel('LDA score')
%     ylabel('First lick time (ms)')
%     title({'Time window = 70 ms'; ...
%         ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%         ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%     set(gca, 'TickDir', 'out')
%     
%     subplot(1, 3, 2)
%     hold on
%     plot(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'ob')
%     plot(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'or')
%     box off
%     hold off
%     xlabel('LDA score')
%     ylabel('First lick time (ms)')
%     title({'Time window = 350 ms'; ...
%         ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%         ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%     set(gca, 'TickDir', 'out')
%     
%     subplot(1, 3, 3)
%     hold on
%     plot(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'ob')
%     plot(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'or')
%     box off
%     hold off
%     xlabel('LDA score')
%     ylabel('First lick time (ms)')
%     title({'Time window = 350 ms'; ...
%         ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%         ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%     set(gca, 'TickDir', 'out')
%     
%     setPrint(8*3, 6, ['Plots/LDAReactionTimeSesssion_idx_' num2str(nSession, '%02d')])
%     
% end

% %% TLDS
% mean_type    = 'Constant_mean';
% tol          = 1e-6;
% cyc          = 10000;
% timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
% timePoint    = timePoint(2:end-1);
% numSession   = length(nDataSet);
% xDimSet      = [2, 2, 4, 2, 3, 2, 4, 2;
%                 0, 3, 0, 0, 4, 0, 0, 3];
% nFold        = 30;
% 
% 
% for nSession = 1:numSession
%     Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
%     numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
%     numTrials   = numYesTrial + numNoTrial;
%     Y          = permute(Y, [2 3 1]);
%     yDim       = size(Y, 1);
%     T          = size(Y, 2);
%     
%     m          = ceil(yDim/4)*2;
%     
%     for nDim   = 1:size(xDimSet, 1)
%         xDim       = xDimSet(nDim, nSession);
%         if xDim>0
%             curr_err   = nan(nFold, 1);
%             for n_fold = 1:nFold
%                 load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(n_fold) '.mat'],'Ph');
%                 [curr_err(n_fold),~] = loo (Y, Ph, [0, timePoint, T]);
%             end
%             [~, optFit] = min(curr_err);
%             load ([TempDatDir 'Session_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%             [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
%             
%             
%             totTargets    = nDataSet(nSession).totTargets;
%             firstLickTime = nDataSet(nSession).firstLickTime;
%             nSessionData  = permute(y_est, [3 1 2]);
%             nSessionData  = normalizationDim(nSessionData, 2);  
%             coeffs        = coeffLDA(nSessionData, totTargets);
%             scoreMat      = nan(numTrials, size(nSessionData, 3));
%             for nTime     = 1:size(nSessionData, 3)
%                 scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%             end
% 
%             figure;
%             subplot(1, 3, 1)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 70 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
% 
%             subplot(1, 3, 2)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 350 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
% 
%             subplot(1, 3, 3)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 350 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
%     
%             setPrint(8*3, 6, ['Plots/TLDSReactionTimeSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
%         end
%     end
% end

% %% GPFA
% timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
% timePoint    = timePoint(2:end-1);
% xDimSet      = [2, 5, 6, 2, 4, 2, 2, 1];
% 
% 
% for nSession = 1:numSession
%     Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
%     numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
%     numTrials   = numYesTrial + numNoTrial;
%     Y          = permute(Y, [2 3 1]);
%     yDim       = size(Y, 1);
%     T          = size(Y, 2);
%     
%     m          = ceil(yDim/4)*2;
%     
%     for nDim   = 1:size(xDimSet, 1)
%         xDim       = xDimSet(nDim, nSession);
%         if xDim>0
%             load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
%             y_est = nan(size(Y));
%             
%             for nTrial = 1:size(Y, 3)
%                 y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
%                 y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
%                 y_est_nTrial (y_est_nTrial <0) = 0;
%                 y_est_nTrial = y_est_nTrial.^2;
%                 y_est(:, :, nTrial) = y_est_nTrial;
%             end
%             
%             
%             totTargets    = nDataSet(nSession).totTargets;
%             firstLickTime = nDataSet(nSession).firstLickTime;
%             nSessionData  = permute(y_est, [3 1 2]);
%             nSessionData  = normalizationDim(nSessionData, 2);  
%             coeffs        = coeffLDA(nSessionData, totTargets);
%             scoreMat      = nan(numTrials, size(nSessionData, 3));
%             for nTime     = 1:size(nSessionData, 3)
%                 scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%             end
% 
%             figure;
%             subplot(1, 3, 1)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 70 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
% 
%             subplot(1, 3, 2)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 350 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-5:5)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
% 
%             subplot(1, 3, 3)
%             hold on
%             plot(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'ob')
%             plot(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'or')
%             box off
%             hold off
%             xlabel('LDA score')
%             ylabel('First lick time (ms)')
%             title({'Time window = 350 ms'; ...
%                 ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%                 ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)+(-10:10)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
%             set(gca, 'TickDir', 'out')
%     
%             setPrint(8*3, 6, ['Plots/GPFAReactionTimeSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
%         end
%     end
% end

%% TLDS
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];


for nSession = 1:numSession
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nDataSet(nSession).firstLickTime;
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
    end

    figure;
    hold on
    plot(mean(scoreMat(totTargets, timePoint(end)+(-1:1)), 2), firstLickTime(totTargets), 'ob')
    plot(mean(scoreMat(~totTargets, timePoint(end)+(-1:1)), 2), firstLickTime(~totTargets), 'or')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
%     title({'Time window = 70 ms'; ...
%         ['contra corr.=' num2str(corr(mean(scoreMat(totTargets, timePoint(end)), 2), firstLickTime(totTargets), 'type', 'Spearman'))]; ...
%         ['ipsi corr.=' num2str(corr(mean(scoreMat(~totTargets, timePoint(end)), 2), firstLickTime(~totTargets), 'type', 'Spearman'))]})
    set(gca, 'TickDir', 'out')    
    setPrint(8, 6, ['Plots/TLDSReactionTimeSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
end

close all