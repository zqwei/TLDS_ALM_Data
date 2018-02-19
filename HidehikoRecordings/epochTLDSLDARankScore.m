addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
cmap                = flipud(cmap);
mCol                = 4;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
timePoints          = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
numEpochs           = 4;
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4, 5, 4, 4, 4, 4, 4, 3];
optFitSets   = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15, 20, 5, 27, 9, 24, 11, 19];
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);


for nSession  = 1:length(nDataSet)
    figure;

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [true(numYesTrial, 1); false(numNoTrial, 1)];
    numUnits      = length(nDataSet(nSession).nUnit);
    numTrials     = numYesTrial + numNoTrial;
    
    mean_yes      = mean(mean(nDataSet(nSession).unit_yes_trial(:, 1:8)));
    mean_no       = mean(mean(nDataSet(nSession).unit_no_trial(:, 1:8)));    
    
    Y          = [nDataSet(nSession).unit_yes_trial - mean_yes; nDataSet(nSession).unit_no_trial - mean_no];
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSets(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
%     [~, y_est, ~] = loo (Y, Ph, [0, timePoints(2:end-1), T]);
    [x_est, y_est] = kfilter (Y, Ph, [0, timePoint, T]);
    nSessionData  = permute(y_est, [3 1 2]);    
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreVec  = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        [~, ~, rankMat(:, nTime)] = unique(scoreVec); % compute rank
        rankMat(:, nTime)         = rankMat(:, nTime)/max(rankMat(:, nTime));
    end
%     rankMat       = rankMat/numTrials;
    sortMat       = sum(rankMat, 2);
    [~, sortMatYes] = sort(sortMat(1:numYesTrial));
    [~, sortMatNo]  = sort(sortMat(1+numYesTrial:end));
    sortIndex       = [sortMatYes; sortMatNo+numYesTrial];
    subplot(1, 3, 1)
    hold on
    imagesc(params.timeSeries, 1:numTrials, rankMat(sortIndex, :), [0 1])
    axis xy
    gridxy ([params.polein, params.poleout, 0],[numYesTrial+0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([1 numTrials])
    set(gca, 'YTick', [1 numTrials]);
    set(gca, 'XTick', -2:2:2);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Trial index')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    
    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreVec  = squeeze(nSessionData(:, :, nTime)) * mean(coeffs, 2);
        [~, ~, rankMat(:, nTime)] = unique(scoreVec); % compute rank
        rankMat(:, nTime)         = rankMat(:, nTime)/max(rankMat(:, nTime));
    end
%     rankMat       = rankMat/numTrials;
    sortMat       = sum(rankMat, 2);
    [~, sortMatYes] = sort(sortMat(1:numYesTrial));
    [~, sortMatNo]  = sort(sortMat(1+numYesTrial:end));
    sortIndex       = [sortMatYes; sortMatNo+numYesTrial];    
    subplot(1, 3, 2)
    hold on
    imagesc(params.timeSeries, 1:numTrials, rankMat(sortIndex, :), [0 1])
    axis xy
    gridxy ([params.polein, params.poleout, 0],[numYesTrial+0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([1 numTrials])
    set(gca, 'YTick', [1 numTrials]);
    set(gca, 'XTick', -2:2:2);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Trial index')
    colormap(cmap)
    set(gca, 'TickDir', 'out')

    rankMat       = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        nEpoch    = sum(params.timeSeries(nTime)>[params.polein, params.poleout, 0])+1;
        scoreVec  = squeeze(nSessionData(:, :, nTime)) * mean(coeffs(:, timePoints(nEpoch):timePoints(nEpoch+1)), 2);
        [~, ~, rankMat(:, nTime)] = unique(scoreVec); % compute rank
        rankMat(:, nTime)         = rankMat(:, nTime)/max(rankMat(:, nTime));
    end
%     rankMat       = rankMat/numTrials;
    sortMat       = sum(rankMat, 2);
    [~, sortMatYes] = sort(sortMat(1:numYesTrial));
    [~, sortMatNo]  = sort(sortMat(1+numYesTrial:end));
    sortIndex       = [sortMatYes; sortMatNo+numYesTrial];        
    subplot(1, 3, 3)
    hold on
    imagesc(params.timeSeries, 1:numTrials, rankMat(sortIndex, :), [0 1])
    axis xy
    gridxy ([params.polein, params.poleout, 0],[numYesTrial+0.5], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    ylim([1 numTrials])
    set(gca, 'YTick', [1 numTrials]);
    set(gca, 'XTick', -2:2:2);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Trial index')
    colormap(cmap)
    set(gca, 'TickDir', 'out')
    

    setPrint(8*3, 6*1, ['Plots/TLDSLDARankExampleSesssion_idx_' num2str(nSession, '%02d')])
    
    close all
end