addpath('../Func');
addpath(genpath('../gpfa_v0203'))
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
numSession   = length(nDataSet);
xDimSet      = [1, 3, 4, 2, 5];
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');


for nSession = 1:numSession    
    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    
    m          = ceil(yDim/4)*2;
    
    for nDim   = 1:size(xDimSet, 1)
        xDim       = xDimSet(nDim, nSession);
        if xDim>0
            load(['GPFAFits/gpfa_optxDimFit_idx_' num2str(nSession) '.mat'])
            y_est = nan(size(Y));
            
            for nTrial = 1:size(Y, 3)
                y_est_nTrial = estParams.C*seqTrain(nTrial).xsm;
%                 y_est_nTrial = bsxfun(@plus, y_est_nTrial, estParams.d);
%                 y_est_nTrial (y_est_nTrial <0) = 0;
%                 y_est_nTrial = y_est_nTrial.^2;
                y_est(:, :, nTrial) = y_est_nTrial;
            end
            
            figure
            
            totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
            nSessionData  = permute(y_est, [3 1 2]);
            nSessionData  = normalizationDim(nSessionData, 2);  
            coeffs        = coeffLDA(nSessionData, totTargets);
            scoreMat      = nan(numTrials, size(nSessionData, 3));
            for nTime     = 1:size(nSessionData, 3)
                scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
            end

            subplot(2, 2, 1)
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

            simCorrMat    = corr(scoreMat, 'type', 'Spearman');

            subplot(2, 2, 2)
            hold on
            imagesc(params.timeSeries, params.timeSeries, simCorrMat);
            xlim([min(params.timeSeries) max(params.timeSeries)]);
            ylim([min(params.timeSeries) max(params.timeSeries)]);
            caxis([0 1]);
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
            subplot(2, 2, 3)
            hold on
            imagesc(params.timeSeries, params.timeSeries, simCorrMat);
            xlim([min(params.timeSeries) max(params.timeSeries)]);
            ylim([min(params.timeSeries) max(params.timeSeries)]);
            caxis([0 1]);
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
            subplot(2, 2, 4)
            hold on
            imagesc(params.timeSeries, params.timeSeries, simCorrMat);
            xlim([min(params.timeSeries) max(params.timeSeries)]);
            ylim([min(params.timeSeries) max(params.timeSeries)]);
            caxis([0 1]);
            axis xy;
            gridxy ([params.polein, params.poleout, 0],[params.polein, params.poleout, 0], 'Color','k','Linestyle','--','linewid', 0.5);
            box off;
            hold off;
            xlabel('LDA score Time (s)')
            ylabel('LDA score Time (s)')
            colormap(cmap)
            title('LDA score rank similarity -- ipsi')
            set(gca, 'TickDir', 'out')
            
            setPrint(8*2, 6*2, ['Plots/GPFASimilarityExampleSesssion_idx_' num2str(nSession, '%02d') '_xDim_' num2str(xDim)])
        end
    end
    
end

close all