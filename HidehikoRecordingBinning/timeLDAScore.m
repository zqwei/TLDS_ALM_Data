addpath('../Func');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;


load([TempDatDir 'DataListSimEphysHi.mat']);

for nData = 1:length(DataSetList)
    load([TempDatDir DataSetList(nData).name '.mat'])
    mRow = ceil(length(nDataSet)/mCol);
    numFold = 10;
    
    for nSession  = 1:5
        figure;

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
        subplot(3, 2, 1)
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
        title('LDA-LDA correlaiton')
        set(gca, 'TickDir', 'out')

        subplot(3, 2, 2)
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
        title('LDA-LDA score using shuffled data')
        set(gca, 'TickDir', 'out')



        numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
        numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
        totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
        numUnits      = length(nDataSet(nSession).nUnit);
        numTrials     = numYesTrial + numNoTrial;
        nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
        nSessionData  = normalizationDim(nSessionData, 2);  
        coeffs        = coeffLDA(nSessionData, totTargets);
        scoreMat      = nan(numTrials, size(nSessionData, 3));
        for nTime     = 1:size(nSessionData, 3)
            scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
            scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime));
        end

        subplot(3, 2, 3)
        hold on
        plot(params.timeSeries, scoreMat(1:8, :), '-b')
        plot(params.timeSeries, scoreMat(numYesTrial+1:numYesTrial+8, :), '-r')
        gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        box off
        hold off
        xlabel('Time (s)')
        ylabel('LDA score')
        title('Score using instantaneous LDA')
        set(gca, 'TickDir', 'out')

        numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
        numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
        totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
        numUnits      = length(nDataSet(nSession).nUnit);
        numTrials     = numYesTrial + numNoTrial;
        nSessionData  = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
        nSessionData  = normalizationDim(nSessionData, 2);  
        coeffs        = coeffLDA(nSessionData, totTargets);
        scoreMat      = nan(numTrials, size(nSessionData, 3));
        for nTime     = 1:size(nSessionData, 3)
            scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        end

        simCorrMat    = corr(scoreMat, 'type', 'Spearman');

        subplot(3, 2, 4)
        hold on
        imagesc(params.timeSeries, params.timeSeries, simCorrMat);
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([min(params.timeSeries) max(params.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity')
        set(gca, 'TickDir', 'out')

        simCorrMat   = abs(corr(scoreMat(1:numYesTrial, :), 'type', 'Spearman'));
        subplot(3, 2, 5)
        hold on
        imagesc(params.timeSeries, params.timeSeries, simCorrMat);
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([min(params.timeSeries) max(params.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity -- contra')
        set(gca, 'TickDir', 'out')

        simCorrMat   = abs(corr(scoreMat(1+numYesTrial:end, :), 'type', 'Spearman'));
        subplot(3, 2, 6)
        hold on
        imagesc(params.timeSeries, params.timeSeries, simCorrMat);
        xlim([min(params.timeSeries) max(params.timeSeries)]);
        ylim([min(params.timeSeries) max(params.timeSeries)]);
        caxis([0 1]);
    %     colorbar
        axis xy;
        gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
        box off;
        hold off;
        xlabel('LDA score Time (s)')
        ylabel('LDA score Time (s)')
        colormap(cmap)
        title('LDA score rank similarity -- ipsi')
        set(gca, 'TickDir', 'out')

        setPrint(8*2, 6*3, ['Plots/' DataSetList(nData).name '_LDASimilarityExampleSesssion_idx_' num2str(nSession, '%02d')])
        
        close all
    end
end