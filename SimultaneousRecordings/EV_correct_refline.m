addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

analysisIndex = [1:8 18 26:42];
explainedCRR = [0.0941971391500321;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190325;0.107332573346359;0.557599484041760;0.364319088067933;0.266487374589105;0.315822647980675;0.178577639473238;0.348245718708246;0.202200748283665;0.278196655269483;0.318707160797709;0.231859581027232;0.308891761309087;0.345569252518441;0.269017745000031;0.284241603848062;0.263076469867423;0.394405188775799;0.446577064694276;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241;NaN]; % from EV_correct_error.m
explainedCRR = explainedCRR(analysisIndex);

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
nDataSet     = nDataSet(analysisIndex);
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
T            = length(params.timeSeries);
numSession   = length(nDataSet);
explainedVRR = nan(numSession, 1); 
numUints     = nan(numSession, 1);


for nSession = 1:numSession-1
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    numUints(nSession)     = yDim;
    err        = evMean (Y, nDataSet(nSession).Ph, [0, timePoint, T], nDataSet(nSession).totTargets);
    explainedVRR(nSession) = 1 - err;
    
end


% figure;
% hold on
% scatter(explainedCRR, explainedVRR, [], numUints, 'filled');
% plot([-0.05 1], [-0.05 1], '--k');
% % colorbar
% hold off
% xlim([-0.05 0.6])
% ylim([-0.05 0.6])
% xlabel('EV TLDS model')
% ylabel('EV Vanilla model')
% set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect')
% close all

figure;
hold on
bar(1:numSession-1, explainedCRR(1:numSession-1),'FaceColor','b')
bar(1:numSession-1, explainedVRR(1:numSession-1),'FaceColor','none')
hold off
box off
xlim([0.5 25.5])
ylim([0 0.701])
xlabel('Session index')
ylabel('Variance explained')
set(gca, 'YTick', [0.0 0.7])
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect')

figure;
hold on
plot(numUints(1:numSession-1), explainedCRR(1:numSession-1)./explainedVRR(1:numSession-1),'ok')
plot([5.5 22.5], [1 1],'--k')
box off
xlim([5.5 22.5])
ylim([0.18 1.3])
set(gca, 'YTick', [0.2 1.3])
set(gca, 'XTick', [6 22])
xlabel('Number units')
ylabel('EV_{TLDS}/EV_{Ref}')
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect_numUnits')