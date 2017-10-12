addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
TLDS_decode  = nan(numSession, 2);
LDA_decode   = nan(numSession, 2);
explainedCRR = [0.0941971391500324;0.216321097217030;0.127652483561879;0.198087983335957;0.357043607042852;0.0840192153190327;0.107332573346359;0.557599484041760;0.127320931929138;0.144772314850104;0.415913774401915;0.182525661848444;0.289938234354398;0.360483221402390;0.466216824758133;0.411115775925481;0.366425364730772;0.438203478685215;0.364274411208107;0.394978241906835;0.406057563091628;0.389362139537689;0.528165743352254;0.583359786983115;0.231085979647241;NaN]; % from EV_correct_error.m
kFold        = 10;


for nSession = 1:numSession-1
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    Y          = permute(Y, [2 3 1]);
    totTargets = nDataSet(nSession).totTargets;
    neuroMat   = squeeze(mean(Y(:, timePoint(end)-0:timePoint(end), :), 2));
    
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat', totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    LDA_decode(nSession,1) = mean(L);
    LDA_decode(nSession,2) = std(L)/sqrt(kFold);
    
    nSessionData  = [nDataSet(nSession).unit_yes_fit; nDataSet(nSession).unit_no_fit];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    neuroMat   = scoreMat(:, timePoint(end));
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat, totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    TLDS_decode(nSession,1) = mean(L);
    TLDS_decode(nSession,2) = std(L)/sqrt(kFold);
    
end


figure
hold on
ploterr(LDA_decode(:,1), TLDS_decode(:,1), LDA_decode(:,2), TLDS_decode(:,2), '.k')
scatter(LDA_decode(:,1), TLDS_decode(:,1), [], explainedCRR, 'filled')
% colorbar
plot([0.5 1], [0.5 1], '--k')
xlim([0.5 1.001])
ylim([0.5 1.001])
xlabel('Performance LDA')
ylabel('Performance TLDS')
set(gca, 'TickDir', 'out')
box off
% setPrint(8, 6, 'Plots/Performance_TLDSScore_late')
