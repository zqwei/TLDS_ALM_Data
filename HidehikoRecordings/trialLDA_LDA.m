%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Similarity of PCA and LDA coefficient vectors as function of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../Func');
setDir;

cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
numFold             = 30;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
mRow = ceil(length(nDataSet)/mCol*2);

figure;

for nSession      = 1:length(nDataSet)
    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    %% compute LDA-LDA of simultaneous recording data
    simCorrMat    = coeffs'*coeffs;

    %% compute LDA-LDA of shuffled recording data
    numT          = size(nSessionData, 3);
    shfCorrMat               = nan(numFold, numT, numT);

    for nFold             = 1:numFold
        nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
        nSessionData = shuffle3DSessionData(nSessionData, totTargets);
        nSessionData = normalizationDim(nSessionData, 2);
        coeffs       = coeffLDA(nSessionData, totTargets);
        shfCorrMat(nFold, :, :) = coeffs'*coeffs;
    end


    %% plots
    subplot(mRow, mCol, nSession*2 - 1)
    hold on
    imagesc(params.timeSeries, params.timeSeries, simCorrMat);
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

    subplot(mRow, mCol, nSession*2)
    hold on
    imagesc(params.timeSeries, params.timeSeries, squeeze(mean(shfCorrMat, 1)));
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
    title({['# trials: ' num2str(numTrials)]; 'Shuffle'})
    set(gca, 'TickDir', 'out')

end

setPrint(8*mCol, 6*mRow, 'Plots/SimilarityLDALDA')

% setColorbar(cmap, 0, 1, 'similarity', 'Plots/SimilarityLDALDA')

close;