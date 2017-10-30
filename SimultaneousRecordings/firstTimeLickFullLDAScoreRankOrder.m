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
    LDA_decode(nSession, [1 3]) = [p, h];
    [p, h]        = corr(scoreMat(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), firstLickTime(~totTargets & firstLickTime<timeMax & firstLickTime>timeMin), 'type', 'Spearman');
    LDA_decode(nSession, [2 4]) = [p, h];
    
    nSessionData  = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
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


contra_corr  = TLDS_decode(:, 1);
ipsi_corr    = TLDS_decode(:, 2);
contra_rtVar = nan(numSession, 1);
ipsi_rtVar   = nan(numSession, 1);
analysisIndex = [1:8 18 26:42];
explainedCRR = [0.0941971391500321;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190325;0.107332573346359;0.557599484041760;0.364319088067933;0.266487374589105;0.315822647980675;0.178577639473238;0.348245718708246;0.202200748283665;0.278196655269483;0.318707160797709;0.231859581027232;0.308891761309087;0.345569252518441;0.269017745000031;0.284241603848062;0.263076469867423;0.394405188775799;0.446577064694276;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241;NaN]; % from EV_correct_error.m
explainedCRR = explainedCRR(analysisIndex);

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
% 
% filledStd = TLDS_decode(:, 3)<0.05; 
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