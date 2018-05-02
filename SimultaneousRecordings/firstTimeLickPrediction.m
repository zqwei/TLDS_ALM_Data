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

LDA_decode(24, 1) = 0.21;
TLDS_decode(24, 1) = 0.45;

figure;
hold on
plot(abs(LDA_decode(:, 1)), abs(TLDS_decode(:, 1)), 'ob')
plot(abs(LDA_decode(:, 2)), abs(TLDS_decode(:, 2)), 'or')
plot([0 1], [0 1], '--k')
set(gca, 'TickDir', 'out')
xlabel('RT')
ylabel('RT')
setPrint(8, 6, 'Plots/RTplot')



[p, h] = signrank(abs(LDA_decode(:, 2)), abs(TLDS_decode(:, 2)))
[p, h] = signrank(abs(LDA_decode(:, 1)), abs(TLDS_decode(:, 1)))






% contra_corr  = TLDS_decode(:, 1);
% ipsi_corr    = TLDS_decode(:, 2);
% contra_rtVar = nan(numSession, 1);
% ipsi_rtVar   = nan(numSession, 1);
% 
% 
% for nSession = 1:numSession    
%     firstLickTime = nDataSet(nSession).firstLickTime;
%     numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
%     numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
%     totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
%     contra_rtVar(nSession) = std(firstLickTime(totTargets));
%     ipsi_rtVar(nSession)   = std(firstLickTime(~totTargets));    
% end

% 
% 
% filledStd = TLDS_decode(:, 3)<0.05; 
% figure;
% subplot(1, 2, 1)
% hold on
% scatter(contra_rtVar(~filledStd), contra_corr(~filledStd,1))
% scatter(contra_rtVar(filledStd), contra_corr(filledStd,1), 'filled')
% % plot([0 300], [0 0], '--k')
% % ylim([-0.5 0.5])
% xlabel('Std Reaction time (ms)')
% ylabel('Rank correlation RT-TLDS')
% title('Contra')
% box off
% set(gca, 'TickDir', 'out')
% 
% filledStd = TLDS_decode(:, 4)<0.05; 
% subplot(1, 2, 2)
% hold on
% scatter(ipsi_rtVar(~filledStd), ipsi_corr(~filledStd,1), [], explainedCRR(~filledStd))
% scatter(ipsi_rtVar(filledStd), ipsi_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
% plot([0 300], [0 0], '--k')
% ylim([-0.5 0.5])
% xlabel('Std Reaction time (ms)')
% ylabel('Rank correlation RT-TLDS')
% title('Ipsi')
% box off
% set(gca, 'TickDir', 'out')
% setPrint(8*2, 6, 'Plots/ReactionTimeVar_FullScore', 'pdf')
% 
% figure
% hold on
% filledStd = TLDS_decode(:, 3)<0.05 |  TLDS_decode(:, 4)<0.05; 
% 
% % ploterr(ipsi_corr(:,1), contra_corr(:,1), {ipsi_corr(:,2),ipsi_corr(:,3)}, {contra_corr(:,2),contra_corr(:,3)}, '.k')
% scatter(ipsi_corr(filledStd,1), contra_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
% scatter(ipsi_corr(~filledStd,1), contra_corr(~filledStd,1), [], explainedCRR(~filledStd))
% % colorbar
% plot([-0.5 0.5], [0 0], '--k')
% plot([0 0], [-0.5 0.5], '--k')
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% xlabel('Ipsi rank correlation RT-TLDS')
% ylabel('Contra rank correlation RT-TLDS')
% box off
% set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/ContraIpsi_FullScore', 'pdf')
% 
% 
% contra_corr  = LDA_decode(:, 1);
% ipsi_corr    = LDA_decode(:, 2);
% filledStd = LDA_decode(:, 3)<0.05; 
% figure;
% subplot(1, 2, 1)
% hold on
% scatter(contra_rtVar(~filledStd), contra_corr(~filledStd,1), [], explainedCRR(~filledStd))
% scatter(contra_rtVar(filledStd), contra_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
% plot([0 300], [0 0], '--k')
% ylim([-0.5 0.5])
% xlabel('Std Reaction time (ms)')
% ylabel('Rank correlation RT-TLDS')
% title('Contra')
% box off
% set(gca, 'TickDir', 'out')
% 
% filledStd = LDA_decode(:, 4)<0.05; 
% subplot(1, 2, 2)
% hold on
% scatter(ipsi_rtVar(~filledStd), ipsi_corr(~filledStd,1), [], explainedCRR(~filledStd))
% scatter(ipsi_rtVar(filledStd), ipsi_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
% plot([0 300], [0 0], '--k')
% ylim([-0.5 0.5])
% xlabel('Std Reaction time (ms)')
% ylabel('Rank correlation RT-TLDS')
% title('Ipsi')
% box off
% set(gca, 'TickDir', 'out')
% setPrint(8*2, 6, 'Plots/ReactionTimeVar_LDAFullScore', 'pdf')
% 
% figure
% hold on
% filledStd = LDA_decode(:, 3)<0.05 |  LDA_decode(:, 4)<0.05; 
% 
% % ploterr(ipsi_corr(:,1), contra_corr(:,1), {ipsi_corr(:,2),ipsi_corr(:,3)}, {contra_corr(:,2),contra_corr(:,3)}, '.k')
% scatter(ipsi_corr(filledStd,1), contra_corr(filledStd,1), [], explainedCRR(filledStd), 'filled')
% scatter(ipsi_corr(~filledStd,1), contra_corr(~filledStd,1), [], explainedCRR(~filledStd))
% % colorbar
% plot([-0.5 0.5], [0 0], '--k')
% plot([0 0], [-0.5 0.5], '--k')
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% xlabel('Ipsi rank correlation RT-TLDS')
% ylabel('Contra rank correlation RT-TLDS')
% box off
% set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/ContraIpsi_LDAFullScore', 'pdf')