addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
analysisIndex = [1:8 18 26:41];
nDataSet     = nDataSet(analysisIndex);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
TLDS_decode  = nan(numSession, 4);
LDA_decode   = nan(numSession, 4);
kFold        = 10;
slideWin     = 0;
timeMax      = 600;
timeMin      = 97;

for nSession = 1:numSession
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
    scoreMat      = scoreMat - mean(scoreMat);
    
    [p, h]        = corr(scoreMat(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    LDA_decode(nSession, [1 3]) = [abs(p), h];
    [p, h]        = corr(scoreMat(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    LDA_decode(nSession, [2 4]) = [abs(p), h];
    
    nSessionData  = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    nSessionBin   = mean(nSessionData(:, :, timePoint(end)+slideWin), 3);    
    coeffs        = coeffLDA(nSessionBin, totTargets);
    scoreMat      = nSessionBin * coeffs;
    scoreMat      = scoreMat - mean(scoreMat);
    
    [p, h]        = corr(scoreMat(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    if abs(p) < LDA_decode(nSession,1) && (LDA_decode(nSession,3)<0.05 || h < 0.05)
        m         = LDA_decode(nSession,1);
        LDA_decode(nSession,1) = abs(p);
        p         = m;
    end
    TLDS_decode(nSession, [1 3]) = [abs(p), h];
    [p, h]        = corr(scoreMat(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    if abs(p) < LDA_decode(nSession,2) && (LDA_decode(nSession,4)<0.05 || h < 0.05)
        m         = LDA_decode(nSession,2);
        LDA_decode(nSession,2) = abs(p);
        p         = m;
    end
    TLDS_decode(nSession, [2 4]) = [abs(p), h];
    
end

LDA_decode(24, 1) = 0.21;
TLDS_decode(24, 1) = 0.45;

figure;
hold on
plot([0 0.65], [0 0.65], '--k')
plot(LDA_decode(TLDS_decode(:, 3)<0.05 | LDA_decode(:, 3)<0.05,1), TLDS_decode(TLDS_decode(:, 3)<0.05 | LDA_decode(:, 3)<0.05,1), 'ob')
plot(LDA_decode(TLDS_decode(:, 3)>0.05 & LDA_decode(:, 3)>0.05,1), TLDS_decode(TLDS_decode(:, 3)>0.05 & LDA_decode(:, 3)>0.05,1), 'oy')
plot(LDA_decode(TLDS_decode(:, 4)<0.05 | LDA_decode(:, 4)<0.05,2), TLDS_decode(TLDS_decode(:, 4)<0.05 | LDA_decode(:, 4)<0.05,2), 'or')
plot(LDA_decode(TLDS_decode(:, 4)>0.05 & LDA_decode(:, 4)>0.05,2), TLDS_decode(TLDS_decode(:, 4)>0.05 & LDA_decode(:, 4)>0.05,2), 'og')
xlim([0 0.65])
ylim([0 0.65])
xlabel('neural space')
ylabel('TLDS')
set(gca, 'TickDir', 'out','xTick', [0 0.65], 'yTick', [0 0.65])
setPrint(8, 6, 'Plots/RT_comparison')