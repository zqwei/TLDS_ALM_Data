addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])

slideWin     = -6:-1;

%%% LDA
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
for nSession      = 16
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = nDataSet(nSession).totTargets;
    firstLickTime = nDataSet(nSession).firstLickTime;
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    nSessionBin   = mean(nSessionData(:, :, timePoint(end)+slideWin), 3);    
    coeffs        = coeffLDA(nSessionBin, totTargets);
    scoreMat      = nSessionBin * coeffs;
    figure;
    hold on;
    [fi, xi] = histcounts(scoreMat(totTargets), -4:0.1:4);
    stairs(xi(1:end-1), fi, 'b')
    [fi, xi] = histcounts(scoreMat(~totTargets), -4:0.1:4);
    stairs(xi(1:end-1), fi, 'r')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
%     xlim([-2.6 2.01])
    set(gca, 'TickDir', 'out')    
%     setPrint(8, 6, ['Plots/LDAScoreHistSesssion_idx_' num2str(nSession, '%02d')])   
    figure;
    hold on
    plot(scoreMat(totTargets), firstLickTime(totTargets), 'ob')
    [p, h] = corr(scoreMat(totTargets), firstLickTime(totTargets), 'type', 'Spearman');
    nTitile = ['r_s=', num2str(p, '%.3f'), ', p=', num2str(h, '%.3f')];
%     x = mean(scoreMat(totTargets, timePoint(end)+slideWin), 2);
%     y = firstLickTime(totTargets);
%     [a, b] = rlinfit(x,y,70);
%     P = [a, b];
%     yfit = P(1)*x+P(2);
%     plot(x, yfit, '-b')
%     plot(mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2), firstLickTime(~totTargets), 'or')
    [p, h] = corr(scoreMat(~totTargets), firstLickTime(~totTargets), 'type', 'Spearman');
    nTitile = {nTitile; ['r_s=', num2str(p, '%.3f'), ', p=', num2str(h, '%.3f')]};
%     x = mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2);
%     y = firstLickTime(~totTargets);
%     [a, b] = rlinfit(x,y,70);
%     P = [a, b];
%     yfit = P(1)*x+P(2);
%     plot(x, yfit, '-r')    
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')    
    title(nTitile);
    set(gca, 'TickDir', 'out')  
%     xlim([-2 1])
%     setPrint(8, 6, ['Plots/LDAReactionTimeSesssion_idx_' num2str(nSession, '%02d')])    
end

%%% TLDS
mean_type    = 'Constant_mean';
tol          = 1e-6;
cyc          = 10000;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
for nSession = 16
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
%     [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);

    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    firstLickTime = nDataSet(nSession).firstLickTime;
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    nSessionBin   = mean(nSessionData(:, :, timePoint(end)+slideWin), 3);    
    coeffs        = coeffLDA(nSessionBin, totTargets);
    scoreMat      = nSessionBin * coeffs;       
    figure;
    hold on;
    [fi, xi] = histcounts(scoreMat(totTargets), -4:0.1:4);
    stairs(xi(1:end-1), fi, 'b')
    [fi, xi] = histcounts(scoreMat(~totTargets), -4:0.1:4);
    stairs(xi(2:end), fi, 'r')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
    set(gca, 'TickDir', 'out') 
%     xlim([-2.01 2.01])
    setPrint(8, 6, ['Plots/TLDSScoreHistSesssion_idx_' num2str(nSession, '%02d')])    
    figure;
    hold on
    plot(scoreMat(totTargets), firstLickTime(totTargets), 'ob');
    [p, h] = corr(scoreMat(totTargets), firstLickTime(totTargets), 'type', 'Spearman');
    nTitile = ['r_s=', num2str(p, '%.3f'), ', p=', num2str(h, '%.3f')];
%     x = mean(scoreMat(totTargets, timePoint(end)+slideWin), 2);
%     y = firstLickTime(totTargets);
%     [a, b] = rlinfit(x,y,70);
%     P = [a, b];
%     yfit = P(1)*x+P(2);
%     plot(x, yfit, '-b')
%     plot(mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2) *4/3, firstLickTime(~totTargets), 'or');
    [p, h] = corr(scoreMat(~totTargets), firstLickTime(~totTargets), 'type', 'Spearman');
    nTitile = {nTitile; ['r_s=', num2str(p, '%.3f'), ', p=', num2str(h, '%.3f')]};
%     x = mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2);
%     y = firstLickTime(~totTargets);
%     [a, b] = rlinfit(x,y,70);
%     P = [a, b];
%     yfit = P(1)*x+P(2);
%     plot(x, yfit, '-r')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
    title(nTitile);
    set(gca, 'TickDir', 'out')  
%     xlim([-2 1])
%     setPrint(8, 6, ['Plots/TLDSReactionTimeSesssion_idx_' num2str(nSession, '%02d')])
end

