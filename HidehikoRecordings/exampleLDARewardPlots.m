addpath('../Func');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
load([TempDatDir 'Simultaneous_HiSpikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'SimultaneousError_HiSpikes.mat'])
mRow = ceil(length(nDataSet)/mCol);
numFold = 10;



for nSession  = 1:length(nDataSet)
    figure;

    numYesTrial   = length(corrDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(corrDataSet(nSession).unit_no_trial_index);
    totTargets    = true(numYesTrial+numNoTrial, 1);
    nSessionData  = [corrDataSet(nSession).unit_yes_trial; corrDataSet(nSession).unit_no_trial];

    numYesTrial   = length(nDataSet(nSession).unit_yes_trial_index);
    numNoTrial    = length(nDataSet(nSession).unit_no_trial_index);
    totTargets    = [totTargets; false(numYesTrial+numNoTrial, 1)];
    
    nSessionData  = [nSessionData; nDataSet(nSession).unit_yes_trial; nDataSet(nSession).unit_no_trial];
    nSessionData  = normalizationDim(nSessionData, 2);  
    [coeffs, ~, ~, correctRate] = coeffSLDA(nSessionData, totTargets);
    scoreMat      = nan(size(nSessionData, 1), size(nSessionData, 3));    
    
    
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
        scoreMat(:, nTime) = scoreMat(:, nTime) - mean(scoreMat(:, nTime)); % remove the momental mean
    end
    
    subplot(1, 2, 1)
    hold on
    scoreMatC     = scoreMat(totTargets, :);
    plot(params.timeSeries, scoreMatC(1:8, :), '-m')
    scoreMatE     = scoreMat(~totTargets, :);
    numErrorTrial = size(scoreMatE, 1);
    plot(params.timeSeries, scoreMatE(1:min(8, numErrorTrial), :), '-g')
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
    % plot(params.timeSeries, correctRate, '-k')
    shadedErrorBar(params.timeSeries, correctRate,sqrt(correctRate.*(1-correctRate)/length(totTargets)),{'-k','linewid',1},0.5);
    gridxy ([params.polein, params.poleout, 0],[mean(totTargets)], 'Color','k','Linestyle','--','linewid', 0.5);
    xlim([min(params.timeSeries) max(params.timeSeries)]);
    box off
    hold off
    xlabel('Time (s)')
    ylabel('Decodability of reward')
    title('Score using instantaneous LDA')
    set(gca, 'TickDir', 'out')
    ylim([0.6 1])
 
    setPrint(8*2, 6*1, ['Plots/LDASimilarityRewardExampleSesssion_idx_' num2str(nSession, '%02d')])
end