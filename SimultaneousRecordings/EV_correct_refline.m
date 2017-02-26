addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

explainedCRR = [0.0941971391500324;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190327;0.107332573346359;0.557599484041760;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241;NaN]; % from EV_correct_error.m

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
explainedVRR = nan(numSession, 1); 
numUints     = nan(numSession, 1);


for nSession = 1:numSession-1
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    numUints(nSession)     = yDim;
    err        = evMean (Y, nDataSet(nSession).Ph, timePoint, nDataSet(nSession).totTargets);
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
bar(explainedCRR, explainedVRR, [], numUints, 'filled');
plot([-0.05 1], [-0.05 1], '--k');
% colorbar
hold off
xlim([-0.05 0.6])
ylim([-0.05 0.6])
xlabel('EV TLDS model')
ylabel('EV Vanilla model')
set(gca, 'TickDir', 'out')
% setPrint(8, 6, 'Plots/LDSModelFit_EV_VanillaCorrect')
% close all