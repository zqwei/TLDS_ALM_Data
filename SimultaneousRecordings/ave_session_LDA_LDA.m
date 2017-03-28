%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Combined_Simultaneous_Spikes.mat'])

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numT         = length(params.timeSeries);
numSess      = length(nDataSet)-1;
simCorrMatSet= nan(numSess, numT, numT);

for nSession      = 1:numSess
    Y             = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = normalizationDim(Y, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    simCorrMatSet(nSession, :, :)    = coeffs'*coeffs;
end

simCorrMat = squeeze(mean(simCorrMatSet, 1));
figure;
hold on
imagesc(params.timeSeries, params.timeSeries, abs(simCorrMat));
xlim([min(params.timeSeries) max(params.timeSeries)]);
ylim([min(params.timeSeries) max(params.timeSeries)]);
caxis([0 1]);
axis xy;
gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
box off;
hold off;
xlabel('LDA Time (s)')
ylabel('LDA Time (s)')
colormap(cmap)
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/SimilarityTLDS_LDALDA_ave_Sesssion')

close all;