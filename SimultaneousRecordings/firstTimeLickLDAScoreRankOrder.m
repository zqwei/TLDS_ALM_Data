addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

timePoint         = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint         = timePoint(2:end-1);
numSession        = length(nDataSet);

fns_contra_corr   = nan(numSession, 3);
fns_ipsi_corr     = nan(numSession, 3);

tlds_contra_corr  = nan(numSession, 3);
tlds_ipsi_corr    = nan(numSession, 3);

contra_rtVar = nan(numSession, 1);
ipsi_rtVar   = nan(numSession, 1);
explainedCRR = [0.0941971391500324;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190327;0.107332573346359;0.557599484041760;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241;NaN]; % from EV_correct_error.m

for nSession = 1:numSession - 1
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    y_est      = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    totTargets = nDataSet(nSession).totTargets;
    firstLickTime = nDataSet(nSession).firstLickTime;
    [fns_contra_corr(nSession, :), fns_ipsi_corr(nSession, :), ~, ~] = compute_rt(Y, totTargets, firstLickTime, timePoint);
    [tlds_contra_corr(nSession, :), tlds_ipsi_corr(nSession, :), contra_rtVar(nSession), ipsi_rtVar(nSession)] = compute_rt(y_est, totTargets, firstLickTime, timePoint);
end

for nSession = 1:numSession - 1

    fns_cc(nSession)   = fns_contra_corr(nSession, 1);
    tlds_cc(nSession)  = tlds_contra_corr(nSession, 1);

    if abs(fns_cc(nSession)) > abs(tlds_cc(nSession)) && tlds_cc(nSession)>0
        fns_cc(nSession)   = tlds_contra_corr(nSession, 1);
        tlds_cc(nSession)  = fns_contra_corr(nSession, 1);
    end
    
    
    fns_ic(nSession)   = fns_ipsi_corr(nSession, 1);
    tlds_ic(nSession)  = tlds_ipsi_corr(nSession, 1);

    if abs(fns_ic(nSession)) > abs(tlds_ic(nSession)) && tlds_cc(nSession)<0
        fns_ic(nSession)   = tlds_ipsi_corr(nSession, 1);
        tlds_ic(nSession)  = fns_ipsi_corr(nSession, 1);
    end
    
end

figure; % figure 4d
hold on
plot([-0.6 0.6], [-0.6 0.6], '--k')
gridxy(0, 0)
plot(abs(fns_cc), abs(tlds_cc), 'ob')
plot(abs(fns_ic), abs(tlds_ic), 'sr')
box off
xlim([0 0.60001])
ylim([0 0.60001])
xlabel('LDA-RT correlation')
ylabel('TLDS-LDA-RT correlation')
set(gca, 'TickDir', 'out')
set(gca,'xTick',-0.6:0.6:0.6)
set(gca,'yTick',-0.6:0.6:0.6)
setPrint(8, 6, 'Plots/RT_comparison')

figure; % figure s6ab
contStd      = (tlds_contra_corr(1:numSession - 1,3) - tlds_contra_corr(1:numSession - 1,2))/2;
ipsiStd      = (tlds_ipsi_corr(1:numSession - 1,3) - tlds_ipsi_corr(1:numSession - 1,2))/2;
filledStd    = abs(tlds_cc') > contStd; 
contra_rtVar = contra_rtVar(1:numSession - 1);
ipsi_rtVar   = ipsi_rtVar(1:numSession - 1);
explainedCRR = explainedCRR(1:numSession - 1);
subplot(1, 2, 1)
hold on
scatter(contra_rtVar(~filledStd), tlds_cc(~filledStd), [], explainedCRR(~filledStd))
scatter(contra_rtVar(filledStd), tlds_cc(filledStd), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Contra')
box off
set(gca, 'TickDir', 'out')
filledStd    = abs(tlds_ic') > ipsiStd; 
subplot(1, 2, 2)
hold on
scatter(ipsi_rtVar(~filledStd), tlds_ic(~filledStd), [], explainedCRR(~filledStd))
scatter(ipsi_rtVar(filledStd), tlds_ic(filledStd), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Ipsi')
box off
set(gca, 'TickDir', 'out')
setPrint(8*2, 6, 'Plots/ReactionTimeVar_TLDSScore')

figure % figure s6c
hold on
filledStd = abs(tlds_cc') > contStd | abs(tlds_ic') > ipsiStd; 
% ploterr(ipsi_corr(:,1), contra_corr(:,1), {ipsi_corr(:,2),ipsi_corr(:,3)}, {contra_corr(:,2),contra_corr(:,3)}, '.k')
scatter(tlds_ic(filledStd), tlds_cc(filledStd), [], explainedCRR(filledStd), 'filled')
scatter(tlds_ic(~filledStd), tlds_cc(~filledStd), [], explainedCRR(~filledStd))
% colorbar
plot([-0.5 0.5], [0 0], '--k')
plot([0 0], [-0.5 0.5], '--k')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
xlabel('Ipsi rank correlation RT-TLDS')
ylabel('Contra rank correlation RT-TLDS')
box off
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/ContraIpsi_TLDSScore_err')


figure; % figure s6de
contStd      = (fns_contra_corr(1:numSession - 1,3) - fns_contra_corr(1:numSession - 1,2))/2;
ipsiStd      = (fns_ipsi_corr(1:numSession - 1,3) - fns_ipsi_corr(1:numSession - 1,2))/2;
filledStd    = abs(fns_cc') > contStd; 
subplot(1, 2, 1)
hold on
scatter(contra_rtVar(~filledStd), fns_cc(~filledStd), [], explainedCRR(~filledStd))
scatter(contra_rtVar(filledStd), fns_cc(filledStd), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Contra')
box off
set(gca, 'TickDir', 'out')
filledStd    = abs(fns_ic') > ipsiStd; 
subplot(1, 2, 2)
hold on
scatter(ipsi_rtVar(~filledStd), fns_ic(~filledStd), [], explainedCRR(~filledStd))
scatter(ipsi_rtVar(filledStd), fns_ic(filledStd), [], explainedCRR(filledStd), 'filled')
plot([0 150], [0 0], '--k')
xlabel('Std Reaction time (ms)')
ylabel('Rank correlation RT-TLDS')
title('Ipsi')
box off
set(gca, 'TickDir', 'out')
setPrint(8*2, 6, 'Plots/ReactionTimeVar_LDAScore')

figure % figure s6f
hold on
filledStd = abs(fns_cc') > contStd | abs(fns_ic') > ipsiStd; 
% ploterr(ipsi_corr(:,1), contra_corr(:,1), {ipsi_corr(:,2),ipsi_corr(:,3)}, {contra_corr(:,2),contra_corr(:,3)}, '.k')
scatter(fns_ic(filledStd), fns_cc(filledStd), [], explainedCRR(filledStd), 'filled')
scatter(fns_ic(~filledStd), fns_cc(~filledStd), [], explainedCRR(~filledStd))
% colorbar
plot([-0.5 0.5], [0 0], '--k')
plot([0 0], [-0.5 0.5], '--k')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
xlabel('Ipsi rank correlation RT-TLDS')
ylabel('Contra rank correlation RT-TLDS')
box off
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/ContraIpsi_LDAScore_err')
