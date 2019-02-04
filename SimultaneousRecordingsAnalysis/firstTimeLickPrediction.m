%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first lick reaction time fit to LDA score in the correct trials
% 
%
% ==========================================
% Ziqiang Wei
% weiz@janelia.hhmi.org
% 2019-02-04
%
%
%
addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])
numSession   = length(nDataSet);
TLDS_decode  = nan(numSession, 4);
LDA_decode   = nan(numSession, 4);
kFold        = 10;
slideWin     = 0;
timeMax      = 600;
timeMin      = 97;

for nSession = 1:numSession
    
    param      = params(nDataSet(nSession).task_type);
    timePoint    = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    timePoint    = timePoint(2:end-1);
    
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = nDataSet(nSession).totTargets;
    firstLickTime = nDataSet(nSession).firstLickTime;
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
%     nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     nSessionData  = [nDataSet(nSession).unit_KFFoward_yes_fit; nDataSet(nSession).unit_KFFoward_no_fit];
    nSessionData  = fitData(nSession).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    nSessionBin   = mean(nSessionData(:, :, timePoint(end)+slideWin), 3);    
    coeffs        = coeffLDA(nSessionBin, totTargets);
    scoreMat      = nSessionBin * coeffs;
    scoreMat      = scoreMat - mean(scoreMat);
    
    [p, h]        = corr(scoreMat(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    LDA_decode(nSession, [1 3]) = [p, h];
    [p, h]        = corr(scoreMat(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    LDA_decode(nSession, [2 4]) = [p, h];
    
    nSessionData  = [nDataSet(nSession).unit_KF_yes_fit; nDataSet(nSession).unit_KF_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    nSessionBin   = mean(nSessionData(:, :, timePoint(end)+slideWin), 3);    
    coeffs        = coeffLDA(nSessionBin, totTargets);
    scoreMat      = nSessionBin * coeffs;
    scoreMat      = scoreMat - mean(scoreMat);
    
    [p, h]        = corr(scoreMat(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    if abs(p) < abs(LDA_decode(nSession,1)) && (LDA_decode(nSession,3)<0.05 || h < 0.05)
        m         = LDA_decode(nSession,1);
        LDA_decode(nSession,1) = p;
        p         = m;
    end
    TLDS_decode(nSession, [1 3]) = [p, h];
    [p, h]        = corr(scoreMat(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    if abs(p) < abs(LDA_decode(nSession,2)) && (LDA_decode(nSession,4)<0.05 || h < 0.05)
        m         = LDA_decode(nSession,2);
        LDA_decode(nSession,2) = p;
        p         = m;
    end
    TLDS_decode(nSession, [2 4]) = [p, h];
    
end

figure;
hold on
plot(abs(LDA_decode(:, 1)), abs(TLDS_decode(:, 1)), 'ob')
plot(abs(LDA_decode(:, 2)), abs(TLDS_decode(:, 2)), 'or')
plot([0 1], [0 1], '--k')
set(gca, 'TickDir', 'out')
xlabel('RT')
ylabel('RT')
setPrint(8, 6, 'Plots/RTplot')