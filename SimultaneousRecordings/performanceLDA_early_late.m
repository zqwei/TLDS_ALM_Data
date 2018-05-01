addpath('../Func');
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_fit.mat'])
numSession   = length(nDataSet);
% TLDS_decode  = nan(numSession, 2);
LDA_decode   = nan(numSession, 2);
kFold        = 10;
slideWin     = 0;

for nSession = 17%1:numSession
    param      = params(nDataSet(nSession).task_type);
    timePoint    = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    timePoint    = timePoint(2:end-1);
    
%     Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
%     Y          = [nDataSet(nSession).unit_KFFoward_yes_fit; nDataSet(nSession).unit_KFFoward_no_fit];
    Y          = fitData(nSession).K8yEst;
    Y          = permute(Y, [2 3 1]);
    totTargets = nDataSet(nSession).totTargets;
    neuroMat   = squeeze(mean(Y(:, timePoint(end)+slideWin, :), 2));
    
    L          = 1 - kfoldLoss(fitcdiscr(neuroMat', totTargets, ...
                 'discrimType','pseudoLinear', 'KFold', kFold),...
                 'lossfun', 'classiferror', 'mode', 'individual');
    LDA_decode(nSession,1) = mean(L);
    LDA_decode(nSession,2) = std(L)/sqrt(kFold);
    
%     nSessionData  = [nDataSet(nSession).unit_KF_yes_fit; nDataSet(nSession).unit_KF_no_fit];
%     nSessionData  = normalizationDim(nSessionData, 2);  
%     coeffs        = coeffLDA(nSessionData, totTargets);
%     scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));
%     for nTime     = 1:size(nSessionData, 3)
%         scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
%     end
%     
%     neuroMat   = mean(scoreMat(:, timePoint(end)+slideWin), 2);
%     L          = 1 - kfoldLoss(fitcdiscr(neuroMat, totTargets, ...
%                  'discrimType','pseudoLinear', 'KFold', kFold),...
%                  'lossfun', 'classiferror', 'mode', 'individual');
%     TLDS_decode(nSession,1) = mean(L);
%     TLDS_decode(nSession,2) = std(L)/sqrt(kFold);
    
end


figure
hold on
ploterr(LDA_decode(:,1), TLDS_decode(:,1), LDA_decode(:,2), TLDS_decode(:,2), '.k')
% scatter(LDA_decode(:,1), TLDS_decode(:,1), [], explainedCRR, 'filled')
scatter(LDA_decode(:,1), TLDS_decode(:,1), 'filled')
[p, h] = signrank(LDA_decode(:,1), TLDS_decode(:,1))
% colorbar
plot([0.5 1], [0.5 1], '--k')
xlim([0.5 1.001])
ylim([0.5 1.001])
xlabel('Performance LDA')
ylabel('Performance TLDS')
set(gca, 'TickDir', 'out')
box off
setPrint(8, 6, 'Plots/Performance_TLDSScore_late')
