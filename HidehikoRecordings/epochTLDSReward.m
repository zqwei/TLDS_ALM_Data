addpath('../Func');
addpath('../Release_LDSI_v3')
setDir;

load([TempDatDir 'Simultaneous_HiSpikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
timePoint    = timePointTrialPeriod(params.polein, params.poleout, params.timeSeries);
timePoint    = timePoint(2:end-1);
numSession   = length(nDataSet);
xDimSet      = [3, 3, 4, 3, 3, 5, 5, 4, 4, 4, 4];
optFitSet    = [4, 25, 7, 20, 8, 10, 1, 14, 15, 10, 15];
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');

for nSession = 1:5;%numSession
    figure;
    Y          = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];
    numYesTrial = size(corrDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(corrDataSet(nSession).unit_no_trial, 1);
    Y          = permute(Y, [2 3 1]);
    T          = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    totTargets    = true(numYesTrial+numNoTrial, 1);
    nSessionData  = permute(y_est, [3 1 2]);

    Y          = [nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    numYesTrial = size(nDataSet(nSession).unit_yes_trial, 1);
    numNoTrial  = size(nDataSet(nSession).unit_no_trial, 1);
    numTrials   = numYesTrial + numNoTrial;
    Y          = permute(Y, [2 3 1]);
    yDim       = size(Y, 1);
    T          = size(Y, 2);
    xDim       = xDimSet(nSession);
    optFit     = optFitSet(nSession);
    load ([TempDatDir 'SessionHi_' num2str(nSession) '_xDim' num2str(xDim) '_nFold' num2str(optFit) '.mat'],'Ph');
    [~, y_est, ~] = loo (Y, Ph, [0, timePoint, T]);
    totTargets    = [totTargets; false(numYesTrial+numNoTrial, 1)];
    nSessionData  = [nSessionData; permute(y_est, [3 1 2])];
            
    nSessionData  = normalizationDim(nSessionData, 2);  
    [coeffs, ~, ~, correctRate] = coeffSLDA(nSessionData, totTargets);
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));    
    
    
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
    end
    
    subplot(1, 2, 1)
    hold on
    plot(params.timeSeries, scoreMat(totTargets, :), '-m')
    plot(params.timeSeries, scoreMat(~totTargets, :), '-g')
    gridxy ([params.polein, params.poleout, 0],[], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('LDA score')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')

    subplot(1, 2, 2)
    hold on
    plot(params.timeSeries, correctRate, '-k')
    gridxy ([params.polein, params.poleout, 0],[mean(totTargets)], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')
    
 
    setPrint(8*2, 6*1, ['Plots/TLDSLDASimilarityRewardExampleSesssion_idx_' num2str(nSession, '%02d')])
end

close all