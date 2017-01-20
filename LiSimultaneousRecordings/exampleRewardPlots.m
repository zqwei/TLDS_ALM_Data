addpath('../Func');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');
mCol                = 4;
load([TempDatDir 'Simultaneous_Spikes.mat'])
corrDataSet  = nDataSet;

load([TempDatDir 'SimultaneousError_Spikes.mat'])
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
    
 
    setPrint(8*2, 6*1, ['Plots/LDASimilarityRewardExampleSesssion_idx_' num2str(nSession, '%02d')])
end

rewardTimeLDA  = [20, 3, 4, 4, 5, 5,  6,   4, 8, 7,   5, 5, 10, 6,  2, 5, 13, 4, 9] * params.binsize;
rewardTimeTLDS = [-1, 2, 4, 1, 1, 3, -9, -32, 4, 1, -15, 1, 0,  1, -7, 1, 2,  0, -1] * params.binsize;

figure;
scatter(rewardTimeLDA, rewardTimeTLDS, [], explainedCRR, 'filled')
hold on
plot([-2.2 1.4], [-2.2 1.4], '--k')
xlim([-2.2 1.4])
ylim([-2.2 1.4])
xlabel('Reward signal time')
ylabel('Reward signal time')
set(gca, 'TickDir', 'out')
setPrint(8, 6, 'Plots/Reward_signal_time')