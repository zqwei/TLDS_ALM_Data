addpath('../Func');
setDir;



slideWin     = -5:0;

%%% LDA

load([TempDatDir 'Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
for nSession      = 1:length(nDataSet)
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = nDataSet(nSession).totTargets;
    firstLickTime = nDataSet(nSession).firstLickTime;
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
%         scoreMat(:, nTime) = scoreMat(:, nTime)./var(scoreMat(:, nTime));
    end
    subplot(5, 5, nSession)
    hold on;
    [fi, xi] = histcounts(mean(scoreMat(totTargets, timePoint(end)+slideWin), 2), -4:0.2:4);
    stairs(xi(1:end-1), fi, 'b')
    [fi, xi] = histcounts(mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2), -4:0.2:4);
    stairs(xi(1:end-1), fi, 'r')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
    xlim([-2.6 2.01])
    set(gca, 'TickDir', 'out')    
end

totSession = length(nDataSet);

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
for nSession      = 1:length(nDataSet)-1
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = nDataSet(nSession).totTargets;
    firstLickTime = nDataSet(nSession).firstLickTime;
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
%         scoreMat(:, nTime) = scoreMat(:, nTime)./var(scoreMat(:, nTime));
    end
    subplot(5, 5, totSession + nSession)
    hold on;
    [fi, xi] = histcounts(mean(scoreMat(totTargets, timePoint(end)+slideWin), 2), -4:0.2:4);
    stairs(xi(1:end-1), fi, 'b')
    [fi, xi] = histcounts(mean(scoreMat(~totTargets, timePoint(end)+slideWin), 2), -4:0.2:4);
    stairs(xi(1:end-1), fi, 'r')
    box off
    hold off
    xlabel('LDA score')
    ylabel('First lick time (ms)')
    xlim([-2.6 2.01])
    set(gca, 'TickDir', 'out')    
end

setPrint(8*5, 6*5, 'LDA_late_delay_all_sessions', 'pdf')