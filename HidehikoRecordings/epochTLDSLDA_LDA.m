%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
numFold             = 30;
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSets   = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);

load([TempDatDir 'Simultaneous_HiSpikes.mat'])


for nSession      = 1:length(nDataSet)
    Y             = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);    
    xDim       = xDimSet(nSession);
    optFit     = optFitSets(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    timePoints  = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);    
    nSessionData  = permute(y_est, [3 1 2]);
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    xCoeffs       = nan(xDim, T);
    
    for nTime     = 1:T
        nEpoch    = sum([0, timePoint, T]<nTime);
        nC        = squeeze(Ph.C(:, :, nEpoch));
        xCoeffs(:, nTime) = nC' * coeffs(:, nTime);
        xCoeffs(:, nTime) = xCoeffs(:, nTime)/sqrt(sum(xCoeffs(:, nTime).^2));
    end

    simCorrMat    = xCoeffs'*xCoeffs;


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
    title({['# units: ' num2str(numUnits)] ; 'Simultaneous'})
    set(gca, 'TickDir', 'out')
    
    setPrint(8, 6, ['Plots/SimilarityTLDS_LDALDA_ExampleSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim) ])

end

close all;