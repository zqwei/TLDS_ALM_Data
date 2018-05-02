addpath('../Func');
addpath('../Release_LDSI_v3');
setDir;
cmap                = cbrewer('div', 'Spectral', 128, 'cubic');


load([TempDatDir 'Combined_Shuffle_Spikes.mat'])
load([TempDatDir 'Combined_data_SLDS_Shf_fit.mat'], 'fitShfData')
load([TempDatDir 'Combined_data_SLDS_fit.mat'], 'fitData')

numShfTrials = 200;

comparison_table = nan(3, 7, 3, length(nDataSet));

% 3 variable -- sim-index in simlt, shf, p-value
% 7 epoch combination
% 3 condition : both, contra, ipsi

for nData = 1:length(nDataSet)
    param          = params(nDataSet(nData).task_type);
    timePoint      = timePointTrialPeriod(param.polein, param.poleout, param.timeSeries);
    
    totTargets    = nDataSet(nData).totTargets;
    numUnits      = length(nDataSet(nData).nUnit);
    numTrials     = length(totTargets);
    numYesTrial   = sum(totTargets);
%     nSessionData  = [nDataSet(nData).unit_KF_yes_fit; nDataSet(nData).unit_KF_no_fit];
%     nSessionData  = [nDataSet(nData).unit_yes_trial; nDataSet(nData).unit_no_trial];
    nSessionData  = fitData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargets);
    scoreMat      = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    
    % shf trials
    totTargetsShf = [true(numShfTrials, 1); false(numShfTrials, 1)];
    numTrials     = length(totTargetsShf);
    numYesTrial   = sum(totTargetsShf);
%     nSessionData  = [nDataSet(nData).unit_KFShf_yes_fit; nDataSet(nData).unit_KFShf_no_fit];
%     nSessionData  = [nDataSet(nData).unit_yes_Shftrial; nDataSet(nData).unit_no_Shftrial];
    nSessionData  = fitShfData(nData).K8yEst;
    nSessionData  = normalizationDim(nSessionData, 2);  
    coeffs        = coeffLDA(nSessionData, totTargetsShf);
    scoreShfMat   = nan(numTrials, size(nSessionData, 3));
    for nTime     = 1:size(nSessionData, 3)
        scoreShfMat(:, nTime) = squeeze(nSessionData(:, :, nTime)) * coeffs(:, nTime);
    end
    
    
    simMat        = abs(corr(scoreMat, 'type', 'spearman'));
    simShfMat     = abs(corr(scoreShfMat, 'type', 'spearman'));
    
    for nEpoch    = 1:length(timePoint)-1
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        indMat    = true(size(simMat_));
        indMat    = tril(indMat, -1);
        simVec    = simMat_(indMat(:));
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        simShfVec = simShfMat_(indMat(:));
        comparison_table(1, nEpoch, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end
    
    for nEpoch    = 1:length(timePoint)-2
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simVec    = simMat_(:);
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simShfVec = simShfMat_(:);
        comparison_table(1, nEpoch+length(timePoint)-1, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end
    
    simMat        = abs(corr(scoreMat(totTargets, :), 'type', 'spearman'));
    simShfMat     = abs(corr(scoreShfMat(totTargetsShf, :), 'type', 'spearman'));
    
    for nEpoch    = 1:length(timePoint)-1
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        indMat    = true(size(simMat_));
        indMat    = tril(indMat, -1);
        simVec    = simMat_(indMat(:));
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        simShfVec = simShfMat_(indMat(:));
        comparison_table(2, nEpoch, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end
    
    for nEpoch    = 1:length(timePoint)-2
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simVec    = simMat_(:);
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simShfVec = simShfMat_(:);
        comparison_table(2, nEpoch+length(timePoint)-1, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end
    
    
    simMat        = abs(corr(scoreMat(~totTargets, :), 'type', 'spearman'));
    simShfMat     = abs(corr(scoreShfMat(~totTargetsShf, :), 'type', 'spearman'));
    
    for nEpoch    = 1:length(timePoint)-1
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        indMat    = true(size(simMat_));
        indMat    = tril(indMat, -1);
        simVec    = simMat_(indMat(:));
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch):timePoint(nEpoch+1));
        simShfVec = simShfMat_(indMat(:));
        comparison_table(3, nEpoch, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end
    
    for nEpoch    = 1:length(timePoint)-2
        simMat_   = simMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simVec    = simMat_(:);
        simShfMat_= simShfMat(timePoint(nEpoch):timePoint(nEpoch+1), timePoint(nEpoch+1):timePoint(nEpoch+2));
        simShfVec = simShfMat_(:);
        comparison_table(3, nEpoch+length(timePoint)-1, :, nData) = [mean(simVec), mean(simShfVec), signrank(simVec, simShfVec)];
    end

    
end

line_color = [ 0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

figure
for n = 1:3
    subplot(1, 3, n)
    hold on
    for nEpoch = 5:7
        comparison_table_slice = squeeze(comparison_table(n, nEpoch, :, :));
        plot(comparison_table_slice(2, comparison_table_slice(3,:)>0.01), comparison_table_slice(1, comparison_table_slice(3,:)>0.01), 'o', 'MarkerEdgeColor', line_color(nEpoch, :), 'MarkerSize', 4)
        plot(comparison_table_slice(2, comparison_table_slice(3,:)<0.01), comparison_table_slice(1, comparison_table_slice(3,:)<0.01), 'o', 'MarkerEdgeColor', line_color(nEpoch, :), 'MarkerFaceColor', line_color(nEpoch, :), 'MarkerSize', 4)
    end
    [p, h] = signrank(reshape(comparison_table(n,:, 1, :), [1, 7*55]), reshape(comparison_table(n,:, 2, :), [1, 7*55]))
    plot([0 1], [0 1], '--k')
    hold off
    xlabel('Average correlation shuffled trials')
    ylabel('Average correlation simul. trials')
    set(gca, 'TickDir', 'out')
end
setPrint(8*3, 6, 'Plots/Shf_Sim_Comparison_Summary')